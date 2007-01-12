From: Alex Tomas <alex@clusterfs.com>
Subject: Re: [PATCH] [RFC] remove ext3 inode from orphan list when link and unlink race
Date: Sat, 13 Jan 2007 01:07:55 +0300
Message-ID: <m3d55jzyo4.fsf@bzzz.home.net>
References: <45A7F384.3050303@redhat.com> <m34pqw0xii.fsf@bzzz.home.net>
	<45A7FA3C.8030209@redhat.com> <m3lkk8ym2f.fsf@bzzz.home.net>
	<45A80213.5060401@redhat.com> <m3hcuvzz88.fsf@bzzz.home.net>
	<45A80544.2030803@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Alex Tomas <alex@clusterfs.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fe02.tochka.ru ([62.5.255.22]:43453 "EHLO umail.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161120AbXALWH7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 12 Jan 2007 17:07:59 -0500
To: Eric Sandeen <sandeen@redhat.com>
In-Reply-To: <45A80544.2030803@redhat.com> (Eric Sandeen's message of "Fri\, 12
	Jan 2007 16\:01\:40 -0600")
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

>>>>> Eric Sandeen (ES) writes:

 ES> Al says "no" and I'm not arguing.  :)

 ES> Apparently this may be OK with some filesystems, and Al says he doesn't
 ES> want to know about i_nlink in the vfs in any case.

well, generic_drop_inode() uses i_nlink ...

 ES> But I suppose there may be other filesystems which DO care, and should
 ES> be checking if they're not.

this is why I thought VFS could take care.

thanks, Alex
