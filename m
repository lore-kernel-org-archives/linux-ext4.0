From: Theodore Tso <tytso@mit.edu>
Subject: Re: [Bug 12676] New: =?utf-8?Q?fs=2Fext4?=
	=?utf-8?Q?=2Fextents=2Ec=3A_In_function__=E2=80=98ext4_ext_search_right?=
	=?utf-8?B?4oCZOiBmcy9leHQ0L2V4dGVudHMuYzoxMTIwOiB3YXJuaW5nOiAg4oCYaXg=?=
	=?utf-8?B?4oCZ?= may be used uninitialized in this function
Date: Tue, 10 Feb 2009 08:25:13 -0500
Message-ID: <20090210132513.GD30689@mini-me.lan>
References: <bug-12676-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: bugme-daemon@bugzilla.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:60537 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752341AbZBJSVc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 Feb 2009 13:21:32 -0500
Content-Disposition: inline
In-Reply-To: <bug-12676-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Feb 09, 2009 at 03:15:49AM -0800, bugme-daemon@bugzilla.kernel.=
org wrote:
> http://bugzilla.kernel.org/show_bug.cgi?id=3D12676
>=20
>            Summary: fs/ext4/extents.c: In function
>                     =E2=80=98ext4_ext_search_right=E2=80=99: fs/ext4/=
extents.c:1120:
>                     warning: =E2=80=98ix=E2=80=99 may be used uniniti=
alized in this
>                     function

> When compiling gets this error on Ext4 FS:
> "fs/ext4/extents.c: In function =E2=80=98ext4_ext_search_right=E2=80=99=
:
> fs/ext4/extents.c:1120: warning: =E2=80=98ix=E2=80=99 may be used uni=
nitialized in this
> function
> "

What version of gcc are you using to compile your kernel?  This looks
like the case of "gcc is stupid not to notice that depth must be
non-zero, so ix is always initialized".  Which doesn't seem to be the
case with gcc 4.3.2, but it might be true with an older version of
gcc.

We can shut up gcc by forcibly initializing ix, but if this is only a
problem with older gcc's, as it seems, it's probably best not to
clutter the source (and the compiled binary) with an unneeded
initialization:

	/* go up and search for index to the right */
	while (--depth >=3D 0) {
		ix =3D path[depth].p_idx;
		if (ix !=3D EXT_LAST_INDEX(path[depth].p_hdr))
			goto got_index;
	}

	/* we've gone up to the root and found no index to the right */
	return 0;

got_index:
	/* we've found index to the right, let's
	 * follow it and find the closest allocated
	 * block to the right */
	ix++;
        ^^^^^ Gee, aren't (some verions of) gcc stupid?


	      	   	  		    	- Ted

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
