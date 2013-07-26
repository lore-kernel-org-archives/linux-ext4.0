From: Vyacheslav Dubeyko <slava@dubeyko.com>
Subject: Re: [RFC/PATCH 0/2] ext4: Transparent Decompression Support
Date: Fri, 26 Jul 2013 11:47:19 +0400
Message-ID: <1374824839.3671.23.camel@slavad-ubuntu>
References: <1374699833.7083.2.camel@localhost>
	 <20130724233628.GD3641@logfs.org> <51F14136.30409@mozilla.com>
	 <51F1556A.20909@mozilla.com>
	 <51FB2C87-854F-4250-9587-B5BBF4E85EE8@dubeyko.com>
	 <51F16B9A.5020006@mozilla.com>
Reply-To: slava@dubeyko.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Dhaval Giani <dgiani@mozilla.com>,
	=?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
	linux-kernel@vger.kernel.org, tytso@mit.edu, vdjeric@mozilla.com,
	glandium@mozilla.com, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: Taras Glek <tglek@mozilla.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <51F16B9A.5020006@mozilla.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, 2013-07-25 at 11:16 -0700, Taras Glek wrote:
> 
> 
> Vyacheslav Dubeyko wrote: 
> > On Jul 25, 2013, at 8:42 PM, Taras Glek wrote:
> > 
> > [snip]
> > > > To introduce transparent decompression. Let someone else do the compression for us, and supply decompressed data on demand  (in this case a read call). Reduces the complexity which would otherwise have to be brought into the filesystem.
> > > The main use for file compression for Firefox(it's useful on Linux desktop too) is to improve IO-throughput and reduce startup latency. In order for compression to be a net win an application should be aware of what is being compressed and what isn't. For example patterns for IO on large libraries (eg 30mb libxul.so) are well suited to compression, but SQLite databases are not.  Similarly for our disk cache: images should not be compressed, but javascript should be. Footprint wins are useful on android, but it's the increased IO throughput on crappy storage devices that makes this most attractive.
> > > 
> > > In addition of being aware of which files should be compressed, Firefox is aware of patterns of usage of various files it could schedule compression at the most optimal time.
> > > 
> > > Above needs tie in nicely with the simplification of not implementing compression at fs-level.
> > 
> > There are many filesystems that uses compression as internal technique. And, as I understand, implementation
> > of compression in different Linux kernel filesystem drivers has similar code patterns. So, from my point of view,
> > it makes sense to generalize compression/decompression code in the form of library. The API of such generalized
> > compression kernel library can be used in drivers of different file systems. Also such generalized compression
> > library will simplify support of compression in file system drivers that don't support compression feature currently.
> > 
> > Moreover, I think that it is possible to implement compression support on VFS level. Such feature gives
> > opportunity to have compression support for filesystems that don't support compression feature as
> > internal technique.
> >From my conversations with Ted, it sounded like it was easier to
> accomplish changes like this at fs level than vfs. Maybe things are
> different now

If I understand the idea correctly, you want to have file-oriented
compression. I mean that you want to have one type of files are
compressed but another type of ones should be not compressed. So, from
my understanding, a file is not ext4 specific concept. Every filesystem
contains files. So, if you intend to implement compression support in
ext4 then you need to use e2compr as basis for full-featured compression
in ext4. But if you want to have something like file-oriented
compression then it is not feature of concrete filesystem. Do you mean
that Firefox will work only on ext4? So, it means for me that feature
likewise file-oriented compression should be on VFS level or over VFS.
And I am not fully confident that it should be a feature in
kernel-space.

> > 
> > [snip]
> > > This transparent decompression idea is based on our experience with HFS+. Apple uses the fs-attribute approach. OSX is able to compress application libraries at installation-time, apps remain blissfully unaware but get an extra boost in startup perf.
> > > 
> > 
> > HFS+ supports compression as internal filesystem technique. It means that HFS+ volume layout has
> > metadata structures for compression support (compressed xattrs or compressed resource forks).
> > So, compression is supported on FS level. As I know, Mac OS X has native decompression support
> > for compressed files but you need to use special tool for compression of files on HFS+. Maybe
> > Mac OS X has internal library that give opportunity to compress application libraries at installation
> > time. But I suppose that it is simply user-space tool or library that uses HFS+ compression support
> > on kernel-space and volume layout levels.
> OSX compression is done in userspace, all heuristics are done in
> userspace. https://github.com/jrk/afsctool/blob/master/afsctool.c#L87 
> Rest of the details are there too. 

Anyway, HFS+ keeps compressed files' content in com.apple.decmpfs xattr
or in resource fork. It means for me that HFS+ volume layout has special
metadata structures for compression support. Because if you will try to
work with HFS+ compressed file under Linux then you will see file with
zero byte in size. And, moreover, Mac OS X filesystem driver should know
about these metadata structures. Otherwise, it cannot process HFS+
compressed files. We can discuss about HFS+ compression in more details
but I think that it is not key topic for this patch set.

With the best regards,
Vyacheslav Dubeyko.

> Taras
> > 
> > With the best regards,
> > Vyacheslav Dubeyko.
> > 


