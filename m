From: Alex Tomas <alex@clusterfs.com>
Subject: Re: [PATCH] return ENOENT from ext3_link when racing with unlink
Date: Wed, 17 Jan 2007 01:07:59 +0300
Message-ID: <m33b6avd4w.fsf@bzzz.home.net>
References: <45ABC572.2070206@redhat.com> <45AD4B20.70507@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
	ext4 development <linux-ext4@vger.kernel.org>, dmonakhov@sw.ru,
	alex@clusterfs.com, Al Viro <viro@ftp.linux.org.uk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fe02.tochka.ru ([62.5.255.22]:45043 "EHLO umail.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751701AbXAPWIg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 16 Jan 2007 17:08:36 -0500
To: Peter Staubach <staubach@redhat.com>
In-Reply-To: <45AD4B20.70507@redhat.com> (Peter Staubach's message of "Tue\, 16
	Jan 2007 17\:01\:04 -0500")
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

>>>>> Peter Staubach (PS) writes:


 PS> Just out of curosity, what keeps i_nlink from going to 0 immediately
 PS> after the new test is executed?

i_mutex in vfs_link() and vfs_unlink()

thanks, Alex
