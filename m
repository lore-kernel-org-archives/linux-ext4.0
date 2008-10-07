From: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: ext4 deadlocks
Date: Tue, 07 Oct 2008 14:54:49 -0700
Message-ID: <48EBDAA9.4080208@goop.org>
References: <48EBB9E9.4030105@goop.org> <48EBC6B9.7000608@sandeen.net> <48EBD448.1010309@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Eric Sandeen <sandeen@sandeen.net>, linux-ext4@vger.kernel.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from gw.goop.org ([64.81.55.164]:60222 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752961AbYJGVzu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 7 Oct 2008 17:55:50 -0400
In-Reply-To: <48EBD448.1010309@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Eric Sandeen wrote:
> ok I can reproduce this too.  I'm guessing this is a migrated ext3
> filesystem?
>   

Yes.  I just used tune2fs on it to enable extents.

> I'll sort out a fix soon.
>
>   

Thanks,
    J
