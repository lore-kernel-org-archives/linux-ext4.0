From: "news.gmane.org" <francois.valenduc@tvcablenet.be>
Subject: EXT4 and selinux
Date: Sat, 12 Sep 2009 12:37:37 +0200
Message-ID: <4AAB79F1.8090703@tvcablenet.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mirapoint21.brutele.be ([212.68.199.158]:18650 "EHLO
	mirapoint21.brutele.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753512AbZILKnl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 12 Sep 2009 06:43:41 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello everybody,

I am using Gentoo and I have recently swicth my SElinux install from
ext3 to ext4 and after
having changed the rlpkq script to also relabel ext4 filesystems, I get
the following errors:
    /usr/sbin/setfiles set context
/usr/sbin/setfilecon->system_u:object_r:bin_t failed:'Operation not
supported'

I have enabled Ext4 Security labels and extended attributes in the
kernel configuration and I am using kernel 2.6.31.However, After having
looked in dmesg, I find lines like this one when an ext4
partition is mounted:
    SELinux: initialized (dev dm-4, type ext4), not configured for labe=
ling

Does anybody know a solution to this problem ?
Thanks in advance for your help.

=46ran=E7ois Valenduc
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
