From: Alex Tomas <alex@clusterfs.com>
Subject: Re: [PATCH] [RFC] remove ext3 inode from orphan list when link and unlink race
Date: Sat, 13 Jan 2007 00:55:51 +0300
Message-ID: <m3hcuvzz88.fsf@bzzz.home.net>
References: <45A7F384.3050303@redhat.com> <m34pqw0xii.fsf@bzzz.home.net>
	<45A7FA3C.8030209@redhat.com> <m3lkk8ym2f.fsf@bzzz.home.net>
	<45A80213.5060401@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Alex Tomas <alex@clusterfs.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fe02.tochka.ru ([62.5.255.22]:40047 "EHLO umail.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161099AbXALVz6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 12 Jan 2007 16:55:58 -0500
To: Eric Sandeen <sandeen@redhat.com>
In-Reply-To: <45A80213.5060401@redhat.com> (Eric Sandeen's message of "Fri\, 12
	Jan 2007 15\:48\:03 -0600")
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

>>>>> Eric Sandeen (ES) writes:
 ES> I tend to agree, chatting w/ Al I think he does too.  :)  I'll test
 ES> a patch that kicks out ext3_link() with -ENOENT at the top, and resubmit
 ES> that if things go well.

shouldn't VFS do that?

thanks, Alex
