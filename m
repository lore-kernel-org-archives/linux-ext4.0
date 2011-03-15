From: Ric Wheeler <ricwheeler@gmail.com>
Subject: Re: Large directories and poor order correlation
Date: Tue, 15 Mar 2011 10:36:03 -0400
Message-ID: <4D7F7953.9080705@gmail.com>
References: <4D7E7990.90209@cfl.rr.com> <4D7E7C7F.1040509@redhat.com> <4D7E8005.4030201@cfl.rr.com> <20110314215249.GE8120@thunk.org> <4D7EA83D.20400@cfl.rr.com> <20110315001448.GG8120@thunk.org> <4D7F7134.7080209@cfl.rr.com> <20110315143300.GC1699@bitwizard.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Phillip Susi <psusi@cfl.rr.com>, Ted Ts'o <tytso@mit.edu>,
	Eric Sandeen <sandeen@redhat.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Rogier Wolff <R.E.Wolff@BitWizard.nl>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:37199 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757849Ab1COOgG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 15 Mar 2011 10:36:06 -0400
Received: by vxi39 with SMTP id 39so607998vxi.19
        for <linux-ext4@vger.kernel.org>; Tue, 15 Mar 2011 07:36:05 -0700 (PDT)
In-Reply-To: <20110315143300.GC1699@bitwizard.nl>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 03/15/2011 10:33 AM, Rogier Wolff wrote:
> On Tue, Mar 15, 2011 at 10:01:24AM -0400, Phillip Susi wrote:
>> To try and clarify this point a bit, are you saying that applications
>> like tar and rsync should be patched to sort the directory by inode
>> number, rather than it being the job of the fs to return entries in a
>> good order?
> IMHO, it is the job of the FS to perform well in common cases.
>
> 	Roger.
>

Some file systems do this well. The thread here is more focused on dealing with 
issues for file systems that handle this poorly :)

Ric

