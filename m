From: Nick Dokos <nicholas.dokos@hp.com>
Subject: Re: [PATCH] Fix ext2fs_set_gdt_csum() to use access functions.
Date: Thu, 03 Sep 2009 01:22:33 -0400
Message-ID: <16130.1251955353@gamaville.dokosmarshall.org>
Reply-To: nicholas.dokos@hp.com
Cc: nicholas.dokos@hp.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from vms173017pub.verizon.net ([206.46.173.17]:47321 "EHLO
	vms173017pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754211AbZICFWg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 3 Sep 2009 01:22:36 -0400
Received: from gamaville.dokosmarshall.org ([98.110.172.159])
 by vms173017.mailsrvcs.net
 (Sun Java(tm) System Messaging Server 6.3-7.04 (built Sep 26 2008; 32bit))
 with ESMTPA id <0KPD00KVNQXKIYZ2@vms173017.mailsrvcs.net> for
 linux-ext4@vger.kernel.org; Thu, 03 Sep 2009 00:22:32 -0500 (CDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Forgot to copy the list...

------- Forwarded Message

Date:    Thu, 03 Sep 2009 01:20:00 -0400
From:    Nick Dokos <nicholas.dokos@hp.com>
To:      Eric Sandeen <sandeen@redhat.com>
cc:      nicholas.dokos@hp.com
Subject: Re: [PATCH] Fix ext2fs_set_gdt_csum() to use access functions.

> Eric Sandeen <sandeen@redhat.com> wrote:
> 
> ...
> right.  Ok, I was just confused when you said "mis-declared" - thought 
> you meant something was wrong with how bg was set or initialized.
> 
Oh, I see: yes, "mis-declared" is not right - it should not exist
at all!-) I'll rephrase it somehow.

Thanks,
Nick


------- End of Forwarded Message

