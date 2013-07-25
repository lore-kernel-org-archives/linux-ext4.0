From: Vyacheslav Dubeyko <slava@dubeyko.com>
Subject: Re: [RFC/PATCH 0/2] ext4: Transparent Decompression Support
Date: Thu, 25 Jul 2013 22:15:23 +0400
Message-ID: <51FB2C87-854F-4250-9587-B5BBF4E85EE8@dubeyko.com>
References: <1374699833.7083.2.camel@localhost> <20130724233628.GD3641@logfs.org> <51F14136.30409@mozilla.com> <51F1556A.20909@mozilla.com>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Dhaval Giani <dgiani@mozilla.com>,
	=?iso-8859-1?Q?J=F6rn_Engel?= <joern@logfs.org>,
	linux-kernel@vger.kernel.org, tytso@mit.edu, vdjeric@mozilla.com,
	glandium@mozilla.com, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: Taras Glek <tglek@mozilla.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:53823 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756928Ab3GYSKG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 25 Jul 2013 14:10:06 -0400
In-Reply-To: <51F1556A.20909@mozilla.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Jul 25, 2013, at 8:42 PM, Taras Glek wrote:

[snip]
>>> 
>> 
>> To introduce transparent decompression. Let someone else do the compression for us, and supply decompressed data on demand  (in this case a read call). Reduces the complexity which would otherwise have to be brought into the filesystem.
> The main use for file compression for Firefox(it's useful on Linux desktop too) is to improve IO-throughput and reduce startup latency. In order for compression to be a net win an application should be aware of what is being compressed and what isn't. For example patterns for IO on large libraries (eg 30mb libxul.so) are well suited to compression, but SQLite databases are not.  Similarly for our disk cache: images should not be compressed, but javascript should be. Footprint wins are useful on android, but it's the increased IO throughput on crappy storage devices that makes this most attractive.
> 
> In addition of being aware of which files should be compressed, Firefox is aware of patterns of usage of various files it could schedule compression at the most optimal time.
> 
> Above needs tie in nicely with the simplification of not implementing compression at fs-level.

There are many filesystems that uses compression as internal technique. And, as I understand, implementation
of compression in different Linux kernel filesystem drivers has similar code patterns. So, from my point of view,
it makes sense to generalize compression/decompression code in the form of library. The API of such generalized
compression kernel library can be used in drivers of different file systems. Also such generalized compression
library will simplify support of compression in file system drivers that don't support compression feature currently.

Moreover, I think that it is possible to implement compression support on VFS level. Such feature gives
opportunity to have compression support for filesystems that don't support compression feature as
internal technique.

[snip]
>> 
> This transparent decompression idea is based on our experience with HFS+. Apple uses the fs-attribute approach. OSX is able to compress application libraries at installation-time, apps remain blissfully unaware but get an extra boost in startup perf.
> 

HFS+ supports compression as internal filesystem technique. It means that HFS+ volume layout has
metadata structures for compression support (compressed xattrs or compressed resource forks).
So, compression is supported on FS level. As I know, Mac OS X has native decompression support
for compressed files but you need to use special tool for compression of files on HFS+. Maybe
Mac OS X has internal library that give opportunity to compress application libraries at installation
time. But I suppose that it is simply user-space tool or library that uses HFS+ compression support
on kernel-space and volume layout levels.

With the best regards,
Vyacheslav Dubeyko.

