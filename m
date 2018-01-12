From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH RFC 03/13] charsets: utf8: Add unicode character database
 files
Date: Fri, 12 Jan 2018 08:59:19 -0800
Message-ID: <20180112165919.GB5594@magnolia>
References: <20180112071234.29470-1-krisman@collabora.co.uk>
 <20180112071234.29470-4-krisman@collabora.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, david@fromorbit.com, bpm@sgi.com, olaf@sgi.com,
        linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        kernel@lists.collabora.co.uk, alvaro.soliverez@collabora.co.uk
To: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:47472 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933994AbeALREk (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 12 Jan 2018 12:04:40 -0500
Content-Disposition: inline
In-Reply-To: <20180112071234.29470-4-krisman@collabora.co.uk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jan 12, 2018 at 05:12:24AM -0200, Gabriel Krisman Bertazi wrote:
> From: Olaf Weber <olaf@sgi.com>
> 
> Add files from the Unicode Character Database, version 7.0.0, to the source.
> A helper program that generates a trie used for normalization from these
> files is part of a separate commit.
> 
> Signed-off-by: Olaf Weber <olaf@sgi.com>
> Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
>   [Move ucd directory to lib/charsets]
> ---
>  lib/charsets/ucd/README | 33 +++++++++++++++++++++++++++++++++
>  1 file changed, 33 insertions(+)
>  create mode 100644 lib/charsets/ucd/README
> 
> diff --git a/lib/charsets/ucd/README b/lib/charsets/ucd/README
> new file mode 100644
> index 000000000000..d713e663cdf9
> --- /dev/null
> +++ b/lib/charsets/ucd/README
> @@ -0,0 +1,33 @@
> +The files in this directory are part of the Unicode Character Database
> +for version 7.0.0 of the Unicode standard.
> +
> +The full set of files can be found here:
> +
> +  http://www.unicode.org/Public/7.0.0/ucd/
> +
> +The latest released version of the UCD can be found here:
> +
> +  http://www.unicode.org/Public/UCD/latest/
> +
> +The files in this directory are identical, except that they have been
> +renamed with a suffix indicating the unicode version.
> +
> +Individual source links:
> +
> +  http://www.unicode.org/Public/7.0.0/ucd/CaseFolding.txt
> +  http://www.unicode.org/Public/7.0.0/ucd/DerivedAge.txt
> +  http://www.unicode.org/Public/7.0.0/ucd/extracted/DerivedCombiningClass.txt
> +  http://www.unicode.org/Public/7.0.0/ucd/DerivedCoreProperties.txt
> +  http://www.unicode.org/Public/7.0.0/ucd/NormalizationCorrections.txt
> +  http://www.unicode.org/Public/7.0.0/ucd/NormalizationTest.txt
> +  http://www.unicode.org/Public/7.0.0/ucd/UnicodeData.txt
> +
> +md5sums
> +
> +  9a92b2bfe56c6719def926bab524fefd  CaseFolding-7.0.0.txt
> +  07b8b1027eb824cf0835314e94f23d2e  DerivedAge-7.0.0.txt
> +  90c3340b16821e2f2153acdbe6fc6180  DerivedCombiningClass-7.0.0.txt
> +  c41c0601f808116f623de47110ed4f93  DerivedCoreProperties-7.0.0.txt
> +  522720ddfc150d8e63a2518634829bce  NormalizationCorrections-7.0.0.txt
> +  1f35175eba4a2ad795db489f789ae352  NormalizationTest-7.0.0.txt
> +  c8355655731d75e6a3de8c20d7e601ba  UnicodeData-7.0.0.txt

Uh... are these files supposed to be attached to this patch?

--D

> -- 
> 2.15.1
> 
