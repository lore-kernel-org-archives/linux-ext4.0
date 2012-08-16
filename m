From: Javier Marcet <jmarcet@gmail.com>
Subject: Re: Far too long mount time
Date: Thu, 16 Aug 2012 11:53:15 +0200
Message-ID: <CAAnFQG__2EzkTSki7VqqOKKQhQOej71_cOeJHyqu2PX6KMn0Vw@mail.gmail.com>
References: <CAAnFQG_O051svcCZftDefebVEds+P1zAceteh=B18HOqmoqitg@mail.gmail.com>
 <CAAnFQG9esXovsAYkCS5Lw5JGpc5dW2PLccvYjN7NvaHLQDqGmA@mail.gmail.com> <0F24AF1B-39C9-4300-862B-B9E84A21E34C@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Linux Ext4 Mailing List <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:52730 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755893Ab2HPJxg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 16 Aug 2012 05:53:36 -0400
Received: by obbuo13 with SMTP id uo13so3451152obb.19
        for <linux-ext4@vger.kernel.org>; Thu, 16 Aug 2012 02:53:36 -0700 (PDT)
In-Reply-To: <0F24AF1B-39C9-4300-862B-B9E84A21E34C@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Aug 16, 2012 at 11:09 AM, Andreas Dilger <adilger@dilger.ca> wrote:

> It is a bit strange that _mounting_ uses 92% CPU.  Hmm, there was a bug
> reported for 3.5.1, see "Re: Upgraded from 3.4 to 3.5.1 kernel: machine
> does not boot", and reverting the patch with git commit hash
> "8aeb00ff85ad25453765dd339b408c0087db1527" resolved the problem.  This
> slowdown was only seen with larger devices.

Thanks a lot Andreas, that commit was the cause. Reverting it:

$ time mount /mnt/raid
0.00s user 0.03s system 5% cpu 0.511 total


-- 
Javier Marcet <jmarcet@gmail.com>
