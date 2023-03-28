#pragma once

#include <Interpreters/Context_fwd.h>
#include <Core/Types.h>

namespace DB
{

template <typename Configuration, typename MetadataReadHelper>
struct HudiMetadataParser
{
    static Strings getFiles(const Configuration & configuration, ContextPtr context);
};

}
