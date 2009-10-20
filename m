From: Doug Hunley <doug@hunley.homeip.net>
Subject: changing stride and stripe_width post-fs-creation?
Date: Tue, 20 Oct 2009 13:32:07 -0400
Message-ID: <7284e2210910201032h74cf437bm6043d97748ece4c9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ew0-f207.google.com ([209.85.219.207]:54349 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096AbZJTRcD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 20 Oct 2009 13:32:03 -0400
Received: by ewy3 with SMTP id 3so5065280ewy.17
        for <linux-ext4@vger.kernel.org>; Tue, 20 Oct 2009 10:32:07 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Is it safe to use tune2fs to alter stride and stripe_width on an ext4
fs once it has been created? Any caveats I should know about? Thanks

-- 
Douglas J Hunley, RHCT
doug.hunley@gmail.com : http://douglasjhunley.com : Twitter: @hunleyd

Obsessively opposed to the typical.
