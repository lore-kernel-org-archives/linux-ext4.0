From: Karel Zak <kzak-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: libuuid (Re: blkid: util-linux-ng vs. e2fsprogs)
Date: Wed, 3 Jun 2009 10:51:40 +0200
Message-ID: <20090603085140.GA4060@nb.net.home>
References: <200905311113.23004.arvidjaar@mail.ru> <20090601124857.GF31943@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrey Borzenkov <arvidjaar-JGs/UdohzUI@public.gmane.org>,
	util-linux-ng-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Theodore Tso <tytso-3s7WtUTddSA@public.gmane.org>,
	Scott James Remnant <scott-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Return-path: <util-linux-ng-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20090601124857.GF31943-3s7WtUTddSA@public.gmane.org>
Sender: util-linux-ng-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Jun 01, 2009 at 08:48:57AM -0400, Theodore Tso wrote:
> It is supposed to be safe to replace the built-in libblkid in
> e2fsprogs with the one in util-linux-ng.  There may be bugs, but if
> there are report them, and we'll work to get them fixed.  I'll try to
> keep the bug fixes in e2fsprogs and util-linux-ng roughly synchronized
> for at least a while, since it takes a while for distributions to make
> the switch.  So a brusque, "drop libblkid, who cares if we screw over
> distro's that haven't yet moved to util-linux-ng" is not in the cards,
> no.  In terms of formal plan, probably in a year or so.  I'm believer
> in long compatibility windows.

 Yes, this is our plan.

 This reminds me...

 The next step is to move libuuid from e2fsprogs to util-linux-ng.
 Currently, this library is widely used by many packages (Fedora-11):

   $ repoquery --qf="%{NAME}" --whatrequires libuuid* | sort -u | wc -l
   74

 The util-linux-ng code is already prepared for this change and the
 library has been merged into git tree.

 It would be nice to add the --disable-uuid option to e2fsprogs. If I
 good remember Scott has a patch for this change. Scott?

    Karel

-- 
 Karel Zak  <kzak-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe util-linux-ng" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
