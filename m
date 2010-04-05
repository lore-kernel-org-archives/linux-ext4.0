From: dmonakhov@openvz.org
Subject: Re: [PATCH 3/3] ext4: optimize quota write locking
Date: Mon, 05 Apr 2010 07:34:36 +0400
Message-ID: <87wrwmy3lf.fsf@openvz.org>
References: <1269692140-5375-1-git-send-email-dmonakhov@openvz.org>
	<1269692140-5375-2-git-send-email-dmonakhov@openvz.org>
	<1269692140-5375-3-git-send-email-dmonakhov@openvz.org>
	<1269692140-5375-4-git-send-email-dmonakhov@openvz.org>
	<20100401091414.GF3322@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:22302 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753889Ab0DEDel (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 4 Apr 2010 23:34:41 -0400
In-Reply-To: <20100401091414.GF3322@quack.suse.cz> (Jan Kara's message of
	"Thu, 1 Apr 2010 11:14:14 +0200")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Jan Kara <jack@suse.cz> writes:

> On Sat 27-03-10 15:15:40, Dmitry Monakhov wrote:
>> Quota inode is append only. In most cases writes performed
>> to allocated blocks before i_size. Currently we grup i_mutex
>> for each quota write to protect i_size and i_mtime. But in most
>> cases i_size not changed. And i_mtime is not that important
>> as for regular files. So let's update it only when quota file
>> increased. This allow us to avoid i_mutex in most cases.
>   But this won't help performance at all because dqio_mutex serializes
> writes to the file already, right?
Oops. This is true. It wasn't true in my private container's tree quota
implementation. So patch is not valid for common case. Please ignore it.
>
> 								Honza
