From: Stephan Kulow <coolo@suse.de>
Subject: Re: ok to stop e4defrag?
Date: Tue, 4 Aug 2009 11:41:47 +0200
Message-ID: <200908041141.47771.coolo@suse.de>
References: <7284e2210908031239q1177490bk41bb0bca63af30da@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Doug Hunley <doug@hunley.homeip.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:47291 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755324AbZHDJls (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 4 Aug 2009 05:41:48 -0400
In-Reply-To: <7284e2210908031239q1177490bk41bb0bca63af30da@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Montag 03 August 2009 sent Doug Hunley:
> I started e4defrag against /dev/md3 on Jul 31 in a screen session, and
> it's still running. I've got a few things coming up shortly that are
> gonna require me to reboot this machine, but I'm not sure if its 'ok'
> to CTRL-C the e4defrag window or not. Advice? Also, how can I tell
> what it's currently working on? I passed the '-v' switch but I've not
> seen any progress indicators in the screen session.

It works fine here and it even outputs progress when not started with -v :)

I _think_ it's still reading the informations of your file system in when
it's not showing any progress.

And yes, there is little chance that you will break something in Ctrl-C
as all dangerous operations are atomic to user space. But don't sue me if I'm 
wrong :)

Greetings, Stephan
