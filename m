From: Marcin M <gmane@mejor.pl>
Subject: Re: kernel thread "flush-254:12" eats 100% CPU
Date: Wed, 07 Sep 2011 19:27:40 +0200
Message-ID: <j489id$322$1@dough.gmane.org>
References: <j483kt$en1$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:40623 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751647Ab1IGR1y (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 7 Sep 2011 13:27:54 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gcfe-linux-ext4@m.gmane.org>)
	id 1R1Luj-00012H-BD
	for linux-ext4@vger.kernel.org; Wed, 07 Sep 2011 19:27:53 +0200
Received: from r1.spray.net.pl ([83.143.40.194])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Wed, 07 Sep 2011 19:27:53 +0200
Received: from gmane by r1.spray.net.pl with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Wed, 07 Sep 2011 19:27:53 +0200
In-Reply-To: <j483kt$en1$1@dough.gmane.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Suplement.
High cpu load appears in random time interval.
All filesystems which has this problem was created with smaller than
default block size. I've got a few other fs with small black size but
thread flush-254 always appear on the same device.

