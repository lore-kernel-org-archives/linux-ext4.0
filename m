From: <muellejo@aschendorff.de>
Subject: Re: ext4 crashes on nfs server
Date: Fri, 27 Jan 2012 13:27:35 +0100
Message-ID: <OFCCAF165E.53B68550-ONC1257992.00447220@aschendorff.de>
References: <OF2380C53F.32FE8350-ONC125798A.00494E7A@aschendorff.de>
	<4F1835F3.9060604@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from isolde.aschendorff.de ([195.66.76.23]:49865 "EHLO
	vam-dom2.aschendorff.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751747Ab2A0M1k (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 27 Jan 2012 07:27:40 -0500
In-Reply-To: <4F1835F3.9060604@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

It happened again several times, this is the first message that appears in syslog related to ext4:

	EXT4-fs (dm-2): Inode 10910806 (ffff88006e445ae8): orphan list check failed!

Here is the complete logfile http://preflight.aschendorff.de/tmp/syslog.1.gz

How can we debug this further ?

Should we kdump the kernel once this happens ?

Thanks
Jo

