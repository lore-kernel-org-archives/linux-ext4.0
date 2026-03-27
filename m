Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67DBA34EEFD
	for <linux-ext4@vger.kernel.org>; Fri, 27 Mar 2026 16:31:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774629107; cv=none; b=l2sMH+nl2Yl4BvFb8D4ZKf63M8mlbA447PF3QdmW5WCXdmAw7NCkWsEPc+O6BADurJSMMAorR6soK/mewUfTX7UAns5xwqSElnJM2VNW6pA6cZURVZLMdcLLLhgWHGYFXGyXdm5/xpl0XDAsUx5Zp0X6Sr60pK8ieSrN7zWJd1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774629107; c=relaxed/simple;
	bh=5UqAhNJoI8sZVtB4wGx9LlUZq6sQ0DfZ4ZYEJrAq9zs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cQSHKmIEh+wYZb5bSLeO52E17DOl7m4yPzwMW3OjOyaZNDi9Rd01rNMNrGWG2Vd+y83vAUzRr4aksCtb6eqbssw3t1OCFPFLQjkCpqlQhj3e0yZotcx0+hwhhEleYUFDetPgwsl2Hc64MoxL8U+3i92Dh+MLEVuHOqVfjWFuDgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=cvln4i0a; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="cvln4i0a"
Received: from macsyma.thunk.org (c-73-9-28-129.hsd1.il.comcast.net [73.9.28.129])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 62RGVaWS012008
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 27 Mar 2026 12:31:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1774629098; bh=yFkxvUWBQnonb4AXcqR2UfeVj+E4LwsMp02yB4sjB/E=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=cvln4i0a2rsqOYHEQqhLQL4wEDp1omc2vj/b6sjsYFy+HDp0oYBcbyx0CzRuYI6R4
	 Ykrz6+jpalF2h9/+e+d0BONwIrm8feGgocKQkozjTikBZtYiGHvHZk3FigdydZgK0M
	 sjhxLZrbumhv1+hXl6MSKH3TlT7TFSqIkILBYk7Ur42TnymokZ6vEqPN11cHRJaKql
	 lDsxiButY08W33J8LUpNag2WWSIsIiAUBMjD5q6REfsKcqr93fqTzfhavG+mPcjv+S
	 IenQFBA0HgFtpEwUdEr8oJcdAtQ0rQd8hfpBiQiakNPffwKH4e+djwXpKdWRTHSwmz
	 JFBzejWPzWVIQ==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id CB6F95F9FDF2; Fri, 27 Mar 2026 11:31:35 -0500 (CDT)
Date: Fri, 27 Mar 2026 11:31:35 -0500
From: "Theodore Tso" <tytso@mit.edu>
To: Deepanshu Kartikey <kartikey406@gmail.com>
Cc: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+fb32afec111a7d61b939@syzkaller.appspotmail.com,
        syzkaller@googlegroups.com
Subject: SYZKALLER BUG: messing with a mounted file system via loop ioctls
 (was: Re: [PATCH] ext4: add bounds check in ext4_xattr_ibody_get() to)
 prevent out-of-bounds access
Message-ID: <20260327163135.GE4383@macsyma.local>
References: <20260224231429.31361-1-kartikey406@gmail.com>
 <20260326054718.GC4383@macsyma.local>
 <CADhLXY5E_4Hi=Uzu3LPwg_YNgcFR+UcAbfY-XzwVnmFBaJqjkA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADhLXY5E_4Hi=Uzu3LPwg_YNgcFR+UcAbfY-XzwVnmFBaJqjkA@mail.gmail.com>

On Fri, Mar 27, 2026 at 08:02:30PM +0530, Deepanshu Kartikey wrote:
> 
> Thank you for the review. I tried moving the fix to check_xattrs()
> as you suggested, but the syzbot reproducer still crashes. I added
> printk statements to trace the code path and found the root cause.
> 
> The issue is that __xattr_check_inode() runs once during ext4_iget(),
> but ext4_xattr_ibody_get() re-reads the inode from disk via
> ext4_get_inode_loc() on every call. The reproducer exploits this by
> shrinking the loop device after mount, causing the re-read to return
> corrupted data.

I consider this more a defect in Syzkaller than in ext4.  Syzkaller
already unsets CONFIG_BLK_DEV_WRITE_MOUNTED because modifying a
mounted file system is not considered a valid security concern.
Unfortunately, the syzkaller fuzzer which corrupts a mounted file
system by messing with a loop device using a privileged ioctl bypasses
!CONFIG_DEV_BLK_WRITE_MOUNTED.

I'll accept a change to add a to check_xattrs(), which will protect
against static corruptions, but adding an extra check to a hotpath
(this would slow down SELinux, which aggressively needs to read the
file's sid) to protect against a corruption issue which requires root
privs is not something I'm interested in.

My priority is improving ext4 --- not reducing the syzkaller reports
against ext4 to zero, since there are false positives like this.  For
people who care about reducing the syzkaller report gamification, my
suggestion is to either extend CONFIG_BLK_DEV_WRITE_MOUNTED to prevent
these loop device reconfiguration while a file system is mounted on
that loop device, or to fix syzkaller to not create fuzzers like this.

Cheers,

						- Ted








> 
> Here is the relevant debug output showing the sequence:
> 
> 1) Inode 12 is loaded, __xattr_check_inode passes with gap=92:
> 
>   DEBUG: inode 12: calling ext4_iget_extra_inode
>   DEBUG: inode 12: __xattr_check_inode called,
>          IFIRST=ffff88805b9f9fa4 end=ffff88805b9fa000 gap=92
> 
> 2) The loop device is then shrunk:
> 
>   loop0: detected capacity change from 1024 to 64
> 
> 3) First access after shrink, inode re-read still looks okay:
> 
>   DEBUG: inode 12: ibody_get
>          IFIRST=ffff88806edbcfa4 end=ffff88806edbd000 gap=92
> 
> 4) Second access, re-read returns corrupted data with gap=-4:
> 
>   DEBUG: inode 12: ibody_get
>          IFIRST=ffff88806edbd004 end=ffff88806edbd000 gap=-4
> 
> 5) Crash follows immediately in xattr_find_entry().
> 
> Note that IFIRST and end are at different addresses between steps
> 1 and 4 - ext4_get_inode_loc() returned a different buffer_head
> with corrupted i_extra_isize, pushing IFIRST 4 bytes past end.
> The initial __xattr_check_inode() validation cannot protect
> against this because it validated the original buffer, not the
> corrupted re-read.
> 
> I think we need both fixes:
> 
>   1) The bounds fix in check_xattrs() as you suggested, changing
>      (void *)next >= end to (void *)next + sizeof(u32) > end
> 
>   2) A bounds check in ext4_xattr_ibody_get() before calling
>      xattr_find_entry(), to catch corrupted re-reads
> 
> Should I submit a v2 with both fixes as a patch series?
> 
> Thanks,
> Deepanshu Kartikey
