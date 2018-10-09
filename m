Return-Path: <SRS0=WpiV=MV=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-pl1-f175.google.com ([209.85.214.175]:42545 "EHLO
        mail-pl1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725855AbeJIK4H (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 9 Oct 2018 06:56:07 -0400
Subject: Re: [BUG] ext4 null pointer crash in linux-next
To: valdis.kletnieks@vt.edu, Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-block@vger.kernel.org
References: <36243.1539028475@turing-police.cc.vt.edu>
From: Bart Van Assche <bvanassche@acm.org>
Message-ID: <839b29df-08af-403c-da3e-e1bc9eca1685@acm.org>
Date: Mon, 8 Oct 2018 20:41:15 -0700
MIME-Version: 1.0
In-Reply-To: <36243.1539028475@turing-police.cc.vt.edu>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 10/8/18 12:54 PM, valdis.kletnieks@vt.edu wrote:
> [  680.692915] RIP: 0010:__get_request+0x31/0x7e0

Can you provide the source code line number that corresponds to that 
address? If you haven't done this before: enter gdb 
${path_to_kernel_source_tree}/vmlinux in a shell and then run "list 
*(__get_request+0x31)" (without the double quotes).

Additionally, which block driver is being used in your setup under the 
ext4 filesystem?

Thanks,

Bart.
