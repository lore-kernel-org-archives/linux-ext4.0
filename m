From: Peter Staubach <staubach@redhat.com>
Subject: Re: [PATCH] return ENOENT from ext3_link when racing with unlink
Date: Tue, 16 Jan 2007 17:15:44 -0500
Message-ID: <45AD4E90.2000203@redhat.com>
References: <45ABC572.2070206@redhat.com> <45AD4B20.70507@redhat.com> <m33b6avd4w.fsf@bzzz.home.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Eric Sandeen <sandeen@redhat.com>,
	linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
	ext4 development <linux-ext4@vger.kernel.org>, dmonakhov@sw.ru,
	Al Viro <viro@ftp.linux.org.uk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:36920 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751433AbXAPWRT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 16 Jan 2007 17:17:19 -0500
To: Alex Tomas <alex@clusterfs.com>
In-Reply-To: <m33b6avd4w.fsf@bzzz.home.net>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Alex Tomas wrote:
>>>>>> Peter Staubach (PS) writes:
>>>>>>             
>
>
>  PS> Just out of curosity, what keeps i_nlink from going to 0 immediately
>  PS> after the new test is executed?
>
> i_mutex in vfs_link() and vfs_unlink()
>   

Ahhh...  Okie doke, thanx!

       ps
