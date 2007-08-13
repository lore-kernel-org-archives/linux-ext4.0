From: Theodore Tso <tytso@mit.edu>
Subject: Re: Future of ext2 support in the Hurd?
Date: Mon, 13 Aug 2007 12:34:44 -0400
Message-ID: <20070813163444.GD28130@thunk.org>
References: <E1IKLAG-0002yi-8Z@candygram.thunk.org> <20070813031336.76A051C0C8@topped-with-meat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: bug-hurd@gnu.org, linux-ext4@vger.kernel.org
To: Roland McGrath <roland@frob.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:58043 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031242AbXHMQes (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 13 Aug 2007 12:34:48 -0400
Content-Disposition: inline
In-Reply-To: <20070813031336.76A051C0C8@topped-with-meat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun, Aug 12, 2007 at 08:13:36PM -0700, Roland McGrath wrote:
> Indeed some people do use the Hurd and they all do rely on the EXT2_OS_HURD
> format support in e2fsprogs.  It's the intended plan to migrate away from
> EXT2_OS_HURD format and use a strict subset of the ext2 format features
> used natively by Linux ext2fs (in theory eventually that whole set).  The
> Hurd-specific data now stored in inode fields in EXT2_OS_HURD format would
> instead be stored in ext2 xattr format.  The extent of cooperation then
> required between ext2 format authorities and Hurd developers is assigning
> an EXT2_XATTR_INDEX_* number to correspond to the "gnu." prefix.  The
> conventions for formats and semantics of attributes with this prefix will
> be maintained by the GNU Project.

Good plan.  :-)  Especially if you end up using a larger inode, and
supporting the EA-in-inode feature, I think you will find a huge speed
boost to files that use translators.  Out of curiosity, do you view
this as something which will be a common case, or an usual one (i.e.,
files using passive translators which are specified in the filesystem)?

Even if you don't, if a large number of files are always using the
same translator, there will probably be some significant disk space
savings with storing that information in an extended attribute.

> If it is important to you and you would like to state a quasi-formal
> schedule to deprecate EXT2_OS_HURD format (not instantaneously), we can
> work with that.  We'd hope for a decent interval of backward compatibility
> support in e2fsck.  (The Hurd code will probably continue to support the
> old format indefinitely.)  Hurd developers can make a small push to get our
> ext2fs code supporting the xattr format encoding of Hurd-specific metadata.
> If you're feeling especially charitable, you could provide format
> conversion support in e2fsprogs.

We don't need to give an explicit schedule, no.  I don't want to force
this to happen fast if the Hurd doesn't have volunteers lined up to do
the work.  As I mentioned earlier, the union is annoying, but it's
hardly a major obstacle to code maintainability.

I am certainly open to including format conversion in e2fprogs, if
someone sends me patches.  I doubt I will have the bandwidth to write
the patches myself in the near future; I have many other todo's on my
plate at the moment.  Working with you to assign a number for the name
index is something that I can help you do.  In fact, I think 7 is
available; why don't I reserve it and then get back to you once it's
been formally merged.

One thing that *would* be useful if you could provide some text (that
would go into the ext2/3/4 wiki) describe exactly what subset of the
ext2 filesystem is currently supported by the Hurd, and what the rough
roadmap you have for supporting additional features.  For example, do
you currently support sparse_superblocks, etc.  BTW, it may be that
you would want to supply a different /etc/mke2fs.conf file in the
e2fsprogs patches so that filesystems created by mke2fs don't include
features that might potentially give the Hurd ext2fs driver heartburn
--- I get the distinct feeling that it hasn't supported many of the
more recent innovations that are in the Linux implementation.

Regards,

						- Ted
