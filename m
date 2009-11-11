From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: [PATCH] resize2fs: exit fix_sb_journal_backup early for external
	journal
Date: Tue, 10 Nov 2009 22:18:38 -0800
Message-ID: <4877c76c0911102218t33407ceal81ef0a1e7367653a@mail.gmail.com>
References: <4AF88220.90908@redhat.com>
	 <4877c76c0911091954p237058cfn2ce9f41cd966d2dc@mail.gmail.com>
	 <4877c76c0911102125t5eef5cf1y228c02ed9c05d3fd@mail.gmail.com>
	 <4AFA4EAF.8040502@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pw0-f42.google.com ([209.85.160.42]:57354 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616AbZKKGSc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 11 Nov 2009 01:18:32 -0500
Received: by pwi3 with SMTP id 3so505815pwi.21
        for <linux-ext4@vger.kernel.org>; Tue, 10 Nov 2009 22:18:38 -0800 (PST)
In-Reply-To: <4AFA4EAF.8040502@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I agree it looks like the right thing to do there, but I'm not sure if
there's some other effect it's supposed to have.

However just based on that small section I should probably be safe if
I use the latest RC kernel (for other ext4 reasons that sound
important) and then do an fsck -f after the resize.
