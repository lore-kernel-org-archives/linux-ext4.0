From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: Shrinking ext3 partition takes long and high CPU usage
Date: Fri, 19 Oct 2012 11:36:14 -0300
Message-ID: <20121019143614.GA15590@andromeda.usersys.redhat.com>
References: <50811EA2.6030603@marsnix.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:16593 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932207Ab2JSOgS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 19 Oct 2012 10:36:18 -0400
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q9JEaIOu010714
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Fri, 19 Oct 2012 10:36:18 -0400
Received: from andromeda.usersys.redhat.com (ovpn-113-113.phx2.redhat.com [10.3.113.113])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id q9JEaFxn028096
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-ext4@vger.kernel.org>; Fri, 19 Oct 2012 10:36:17 -0400
Content-Disposition: inline
In-Reply-To: <50811EA2.6030603@marsnix.nl>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Oct 19, 2012 at 11:34:26AM +0200, Marcel van Beurden wrote:
> Hi,
> 
> I'm in the process of shrinking a 900 GB ext3 partition on a USB2
> connected disk using Gparted (0.5.1-1ubuntu3). The whole thing has
> been running for 2 days now and I'm curious whether it will ever
> finish. Right now the resize2fs (sub)process is using 99% of one
> 3.2GHz Xeon core (totalling up to 32 hours of CPU time so far).
> 
> Is resize2fs being stuck and hanging forever, or is it just taking a
> lot of time? I wouldn't expect resizing to be so CPU intensive.
> 
Hi, is not possible to answer this with just the information you provided. I
would expect to see soft lockup warnings on the system log if it was really
stuck.

A stack trace of the resize2fs process (sysrq-t) might give some information
about what's going on.

You're using a too olde resize2fs so, may be possible you're using a buggy
version too, but I'm not the best person to say if there was any bug on
resize2fs which might be causing this.

Also, I hope you're trying to shrink the filesystem with this umounted :-)

> Is there any way to check whether it is still doing anything and to
> estimate when it will be done?
> How corrupt will be filesystem be when I press ctrl-C?
> 
> Version of resize2fs is: 1.41.11 (14-Mar-2010)
> Version of linux kernel:  2.6.32-40-generic-pae
> 
> Regards,
> Marcel
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
--Carlos
