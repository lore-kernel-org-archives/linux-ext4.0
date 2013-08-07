From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Subject: Re: [RFC/PATCH 0/2] ext4: Transparent Decompression Support
Date: Wed, 7 Aug 2013 11:52:13 -0400
Message-ID: <20130807155212.GB18545@logfs.org>
References: <51F14136.30409@mozilla.com>
 <51F1556A.20909@mozilla.com>
 <51FB2C87-854F-4250-9587-B5BBF4E85EE8@dubeyko.com>
 <51F17005.7030309@mozilla.com>
 <1374825683.3671.35.camel@slavad-ubuntu>
 <20130726132034.GB21977@logfs.org>
 <20130804003316.GA19781@thunk.org>
 <20130804022114.GA24655@logfs.org>
 <20130804234824.GB7118@dastard>
 <1CC5EF89-C66F-4AB7-A3E6-162D7E17E671@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Dave Chinner <david@fromorbit.com>, Theodore Ts'o <tytso@mit.edu>,
	Vyacheslav Dubeyko <slava@dubeyko.com>,
	Dhaval Giani <dgiani@mozilla.com>,
	Taras Glek <tglek@mozilla.com>, linux-kernel@vger.kernel.org,
	vdjeric@mozilla.com, glandium@mozilla.com,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from longford.logfs.org ([213.229.74.203]:60018 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756925Ab3HGRY5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 7 Aug 2013 13:24:57 -0400
Content-Disposition: inline
In-Reply-To: <1CC5EF89-C66F-4AB7-A3E6-162D7E17E671@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 7 August 2013 03:21:47 -0600, Andreas Dilger wrote:
>=20
> I'm not saying that a tool to check this would be a bad thing, but
> if the compression support is a generic feature of the VFS, then it
> makes sense that the checker can also be generic and unrelated to
> the filesystem metadata checking as well.  It may be "gunzip -t"
> or LZO equivalent is enough to determine if the file is/isn't in a

Careful!  If you have a 1GB file in gzip format and want to
demand-page the last page from it, you have to gunzip the _entire_
file before you can uncompress that page.  There is no alternative to
splitting the file into chunks of some reasonable size and therefore
"gunzip -t" will never be enough.

That also means that data corruption has more impact here than it
would have for an uncompressed file.  Instead of handing the corrupted
data to userspace and let it deal with the results, the kernel has to
interpret some header, some list of chunks and finally the compression
format.  Any bugs here will lead to crashes or privilege escalations
that we are responsible for.  We cannot just say "garbage in, garbage
out, let userspace handle it".

Do we return zero-filled pages in case of data corruption?  Or should
we return -EIO on reads and segfault on access of mmap'ed pages?  Or
does the filesystem really own the metadata, which in this case
includes the header and chunk list and potentially some bits of the
compression format, and adds checksums, etc. to said metadata?

J=C3=B6rn

--
Somewhere around the year 2000 there was this turningpoint when it
became cheaper to collect information than to understand it.
-- Freeman Dyson
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
