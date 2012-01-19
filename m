From: <muellejo@aschendorff.de>
Subject: Re: newsletter: Re: ext4 crashes on nfs server
Date: Thu, 19 Jan 2012 18:07:33 +0100
Message-ID: <OFBE4B8BA4.837045FD-ONC125798A.005E13C5@aschendorff.de>
References: <OF2380C53F.32FE8350-ONC125798A.00494E7A@aschendorff.de>
	<4F1835F3.9060604@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.print.wnonline.de ([195.66.76.20]:3391 "EHLO
	vam-dom2.aschendorff.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752847Ab2ASRHg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 19 Jan 2012 12:07:36 -0500
In-Reply-To: <4F1835F3.9060604@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Thanks Eric,

> Looks like an oops/panic/BUG - but are you sure you didn't start copying a line or two too late?

Well, there are other interesting information in /var/log/messages about 10 minutes
I uploaded them here http://vam-emp.aschendorff.de/tmp/

We also suffered from a huge amount from these log entries
they are somehow related to disabling ipv6 and vsftp but I
guess this is not really related to our ext4 crashes.
After now upgrading vsftp they disappeared, debian has got a bug for that
http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=590653

Jan 18 20:52:26 ez-nfs-prod-vm1 kernel: [14913.361952] lo: Disabled Privacy Extensions

Thanks
