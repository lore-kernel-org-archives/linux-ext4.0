From: "Weber, Olaf (HPC Data Management & Storage)" <olaf.weber@hpe.com>
Subject: RE: [PATCH RFC 03/13] charsets: utf8: Add unicode character database
 files
Date: Fri, 12 Jan 2018 20:29:01 +0000
Message-ID: <DF4PR8401MB081230306211258EA6D8926385170@DF4PR8401MB0812.NAMPRD84.PROD.OUTLOOK.COM>
References: <20180112071234.29470-1-krisman@collabora.co.uk>
 <20180112071234.29470-4-krisman@collabora.co.uk>
 <20180112165919.GB5594@magnolia>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "tytso@mit.edu" <tytso@mit.edu>,
        "david@fromorbit.com" <david@fromorbit.com>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "kernel@lists.collabora.co.uk" <kernel@lists.collabora.co.uk>,
        "alvaro.soliverez@collabora.co.uk" <alvaro.soliverez@collabora.co.uk>
To: "Darrick J. Wong" <darrick.wong@oracle.com>,
        Gabriel Krisman Bertazi <krisman@collabora.co.uk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from g2t1383g.austin.hpe.com ([15.233.16.89]:19700 "EHLO
        g2t1383g.austin.hpe.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964847AbeALU3G (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 12 Jan 2018 15:29:06 -0500
In-Reply-To: <20180112165919.GB5594@magnolia>
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> -----Original Message-----
> From: Darrick J. Wong [mailto:darrick.wong@oracle.com]
> Sent: Friday, January 12, 2018 17:59
> To: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
> Cc: tytso@mit.edu; david@fromorbit.com; bpm@sgi.com; olaf@sgi.com;
> linux-ext4@vger.kernel.org; linux-fsdevel@vger.kernel.org;
> kernel@lists.collabora.co.uk; alvaro.soliverez@collabora.co.uk
> Subject: Re: [PATCH RFC 03/13] charsets: utf8: Add unicode character
> database files
> 
> On Fri, Jan 12, 2018 at 05:12:24AM -0200, Gabriel Krisman Bertazi wrote:
> > From: Olaf Weber <olaf@sgi.com>
> >
> > Add files from the Unicode Character Database, version 7.0.0, to the
> source.
> > A helper program that generates a trie used for normalization from
> > these files is part of a separate commit.
> >
> > Signed-off-by: Olaf Weber <olaf@sgi.com>
> > Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
> >   [Move ucd directory to lib/charsets]
> > ---
> >  lib/charsets/ucd/README | 33 +++++++++++++++++++++++++++++++++
> >  1 file changed, 33 insertions(+)
> >  create mode 100644 lib/charsets/ucd/README
> >
> > diff --git a/lib/charsets/ucd/README b/lib/charsets/ucd/README new
> > file mode 100644 index 000000000000..d713e663cdf9
> > --- /dev/null
> > +++ b/lib/charsets/ucd/README
> > @@ -0,0 +1,33 @@
> > +The files in this directory are part of the Unicode Character
> > +Database for version 7.0.0 of the Unicode standard.
> > +
> > +The full set of files can be found here:
> > +
> > +  http://www.unicode.org/Public/7.0.0/ucd/
> > +
> > +The latest released version of the UCD can be found here:
> > +
> > +  http://www.unicode.org/Public/UCD/latest/
> > +
> > +The files in this directory are identical, except that they have been
> > +renamed with a suffix indicating the unicode version.
> > +
> > +Individual source links:
> > +
> > +  http://www.unicode.org/Public/7.0.0/ucd/CaseFolding.txt
> > +  http://www.unicode.org/Public/7.0.0/ucd/DerivedAge.txt
> > +
> > +
> http://www.unicode.org/Public/7.0.0/ucd/extracted/DerivedCombiningCl
> > + ass.txt
> > + http://www.unicode.org/Public/7.0.0/ucd/DerivedCoreProperties.txt
> > +
> > + http://www.unicode.org/Public/7.0.0/ucd/NormalizationCorrections.txt
> > +  http://www.unicode.org/Public/7.0.0/ucd/NormalizationTest.txt
> > +  http://www.unicode.org/Public/7.0.0/ucd/UnicodeData.txt
> > +
> > +md5sums
> > +
> > +  9a92b2bfe56c6719def926bab524fefd  CaseFolding-7.0.0.txt
> > + 07b8b1027eb824cf0835314e94f23d2e  DerivedAge-7.0.0.txt
> > +  90c3340b16821e2f2153acdbe6fc6180  DerivedCombiningClass-7.0.0.txt
> > +  c41c0601f808116f623de47110ed4f93  DerivedCoreProperties-7.0.0.txt
> > + 522720ddfc150d8e63a2518634829bce  NormalizationCorrections-7.0.0.txt
> > +  1f35175eba4a2ad795db489f789ae352  NormalizationTest-7.0.0.txt
> > + c8355655731d75e6a3de8c20d7e601ba  UnicodeData-7.0.0.txt
> 
> Uh... are these files supposed to be attached to this patch?

Actually, no, as was explained in the 1st message:

" Like the original submission from Ben, I excluded the commit that includes the
" generated header file and unicode files because they are too big and would
" bounce the list.  Instead, instructions on fetching and generating the files are
" documented in the commit message.

One issue we (SGI) anticipated is that we were proposing the inclusion of a large binary blob into
the kernel. And people here do dislike opaque binary blobs. So instead we proposed including the
program that generated the blob in question plus the source files it uses. On the one hand, a
sizable increase of the kernel source tree, on the other hand, no argument about the provenance
of the blob as both source and generator are right there.

An alternative might be to include the generated blob itself but retain the instructions so people can
verify it, providing they cared to do so. If someone was really ambitious, they could even automate
grabbing the source files from unicode.org as part of a verification build. If they were even more
ambitious, they could add such a verification build as an option to the linux kernel build system. (In
other words, I am not the one who's going to implement this if it turns out that people on this list
believe this to be a good idea.)

Olaf
