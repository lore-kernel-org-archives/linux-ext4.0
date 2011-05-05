From: Niraj Kulkarni <kulkarniniraj14@gmail.com>
Subject: Re: [PATCH] jbd/jbd2: remove obsolete summarise_journal_usage.
Date: Thu, 05 May 2011 21:48:34 +0530
Message-ID: <4DC2CDDA.2000406@gmail.com>
References: <1304610859-480-1-git-send-email-tm@tao.ma> <20110505161454.GM5323@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Tao Ma <tm@tao.ma>, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:39764 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754994Ab1EEQUB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 5 May 2011 12:20:01 -0400
Received: by pwi15 with SMTP id 15so1048980pwi.19
        for <linux-ext4@vger.kernel.org>; Thu, 05 May 2011 09:20:00 -0700 (PDT)
In-Reply-To: <20110505161454.GM5323@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,
     I have a question, if only one instance of kjournald is active at 
any time, and committing transaction is well separated from others, what 
is need of taking j_list_lock while operating on committing 
transaction's lists?

Niraj
