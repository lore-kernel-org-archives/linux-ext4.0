From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: possible ext4 race situation freezing linux
Date: Wed, 04 Mar 2009 00:56:04 -0600
Message-ID: <49AE2604.8080107@redhat.com>
References: <1235478142.11758.9.camel@localhost.localdomain>	 <20090224141749.GC5482@mit.edu> <49A41469.6090604@redhat.com>	 <1235495013.11758.37.camel@localhost.localdomain>	 <20090224173031.GE5482@mit.edu> <1236148970.4674.3.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Andreas Friedrich Berendsen <afberendsen@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:51496 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752034AbZCDG4v (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 4 Mar 2009 01:56:51 -0500
In-Reply-To: <1236148970.4674.3.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andreas Friedrich Berendsen wrote:
>  Ts'o,
> 
> Problem still exist. Now, when executing 'fsck.ext4 -C 0 -F -y -v' I
> receive a list of inodes, and at certain point system freezes.

so now it's freezing when ext4 isn't even mounted but simply being
fsck'd?  This may point to a generic storage problem.

> Attached I'm sending the output for SysRq as requested

$ zcat messages.gz | grep -i sysrq
$

The sysrq output didn't seem to make it to that log.

-Eric
