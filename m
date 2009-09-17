From: jehan procaccia <jehan.procaccia@it-sudparis.eu>
Subject: ext4 and quota generate "Data will be lost" errors :-(
Date: Thu, 17 Sep 2009 15:49:52 +0200
Message-ID: <4AB23E80.9070805@it-sudparis.eu>
Reply-To: jehan.procaccia@it-sudparis.eu
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp4.int-evry.fr ([157.159.10.71]:39061 "EHLO
	smtp4.int-evry.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937AbZIQOXx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 17 Sep 2009 10:23:53 -0400
Received: from smtp2.int-evry.fr (smtp2.int-evry.fr [157.159.10.45])
	by smtp4.int-evry.fr (Postfix) with ESMTP id DF9F4FE2E82
	for <linux-ext4@vger.kernel.org>; Thu, 17 Sep 2009 15:49:58 +0200 (CEST)
Received: from smtp-ext.int-evry.fr (smtp-ext.int-evry.fr [157.159.11.17])
	by smtp2.int-evry.fr (Postfix) with ESMTP id 9B271405019
	for <linux-ext4@vger.kernel.org>; Thu, 17 Sep 2009 15:49:54 +0200 (CEST)
Received: from [157.159.50.197] (PAT7414.micro.int-evry.fr [157.159.50.197])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp-ext.int-evry.fr (Postfix) with ESMTP id 5E2D890011
	for <linux-ext4@vger.kernel.org>; Thu, 17 Sep 2009 15:49:54 +0200 (CEST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Since I run a ext4 FS with quota on my Redhat 5.4 , I often get these 
kind of messages on the console:

Message from syslogd@ at Thu Sep 17 15:40:11 2009 ...
gizeh kernel: mpage_da_map_blocks block allocation failed for inode 
3412191 at logical offset 0 with max blocks 1 with error -122
Message from syslogd@ at Thu Sep 17 15:40:11 2009 ...
gizeh kernel: This should not happen.!! Data will be lost

my system is runing on:
$ uname -a
Linux gizeh.int-evry.fr 2.6.18-164.el5 #1 SMP Tue Aug 18 15:51:48 EDT 
2009 x86_64 x86_64 x86_64 GNU/Linux
$ rpm -q quota
quota-3.16-7 
I upgraded redhat quota package from recompile fedora10 sources because 
of this changelog:

* Thu Oct 30 2008 Ondrej Vasik <ovasik@redhat.com <mailto:ovasik@redhat.com>> 1:3.16-6
- fix implementation of ext4 support


I have a discussion with redhat on this: 
https://bugzilla.redhat.com/show_bug.cgi?id=522615
the reponse is to move back to ext3 until redhat support quota for ext4 .

my probleme is that I have lot of users and filesystems in this 
situation now, and I wonder I couldn't expect a workaround ?
is this issue know in recent kernel,  will I really lose data ? 
any advice greatly appreciated .

regards


