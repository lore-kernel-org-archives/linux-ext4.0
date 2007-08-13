From: Roland McGrath <roland@frob.com>
Subject: Re: Future of ext2 support in the Hurd?
Date: Sun, 12 Aug 2007 20:13:36 -0700 (PDT)
Message-ID: <20070813031336.76A051C0C8@topped-with-meat.com>
References: <E1IKLAG-0002yi-8Z@candygram.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, bug-hurd@gnu.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <bug-hurd-bounces+gnu-bug-hurd=m.gmane.org@gnu.org>
In-Reply-To: Theodore Ts'o's message of  Sunday, 12 August 2007 17:40:00 -0400
	<E1IKLAG-0002yi-8Z@candygram.thunk.org>
List-Unsubscribe: <http://lists.gnu.org/mailman/listinfo/bug-hurd>,
	<mailto:bug-hurd-request@gnu.org?subject=unsubscribe>
List-Archive: <http://lists.gnu.org/pipermail/bug-hurd>
List-Post: <mailto:bug-hurd@gnu.org>
List-Help: <mailto:bug-hurd-request@gnu.org?subject=help>
List-Subscribe: <http://lists.gnu.org/mailman/listinfo/bug-hurd>,
	<mailto:bug-hurd-request@gnu.org?subject=subscribe>
Sender: bug-hurd-bounces+gnu-bug-hurd=m.gmane.org@gnu.org
Errors-To: bug-hurd-bounces+gnu-bug-hurd=m.gmane.org@gnu.org
List-Id: linux-ext4.vger.kernel.org

The license issues are not directly apropos to the main subject of
cooperation on supporting a particular disk format, so I'll leave that
aside.  Let us discuss the future of the EXT2_OS_HURD variant of ext2 format.

Indeed some people do use the Hurd and they all do rely on the EXT2_OS_HURD
format support in e2fsprogs.  It's the intended plan to migrate away from
EXT2_OS_HURD format and use a strict subset of the ext2 format features
used natively by Linux ext2fs (in theory eventually that whole set).  The
Hurd-specific data now stored in inode fields in EXT2_OS_HURD format would
instead be stored in ext2 xattr format.  The extent of cooperation then
required between ext2 format authorities and Hurd developers is assigning
an EXT2_XATTR_INDEX_* number to correspond to the "gnu." prefix.  The
conventions for formats and semantics of attributes with this prefix will
be maintained by the GNU Project.

Of course, I've been saying this was the plan for several years, and very
few steps of that migration have begun.  (You're probably not eager to see
my dusty patches for Linux ext2fs to support EXT2_OS_HURD format by mapping
its special data items to virtual xattrs with gnu.* names. :-) 

If it is important to you and you would like to state a quasi-formal
schedule to deprecate EXT2_OS_HURD format (not instantaneously), we can
work with that.  We'd hope for a decent interval of backward compatibility
support in e2fsck.  (The Hurd code will probably continue to support the
old format indefinitely.)  Hurd developers can make a small push to get our
ext2fs code supporting the xattr format encoding of Hurd-specific metadata.
If you're feeling especially charitable, you could provide format
conversion support in e2fsprogs.


Thanks,
Roland
