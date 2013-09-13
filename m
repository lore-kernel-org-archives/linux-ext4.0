From: Ric Wheeler <ricwheeler@gmail.com>
Subject: Re: Please help: Is ext4 counting trims as writes, or is something
 killing my SSD?
Date: Fri, 13 Sep 2013 09:41:22 -0400
Message-ID: <52331602.4050404@gmail.com>
References: <20130912141856.GA17640@jak-x230> <1378997643.28638.53.camel@hp-a6734f> <5231DB33.9090104@redhat.com> <20130912153232.GA19548@jak-x230> <5231E346.5030000@redhat.com> <20130912184732.GA28067@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Eric Sandeen <sandeen@redhat.com>,
	Julian Andres Klode <jak@jak-linux.org>,
	Calvin Walton <calvin.walton@kepstin.ca>,
	linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qc0-f173.google.com ([209.85.216.173]:38647 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757955Ab3IMNlZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 13 Sep 2013 09:41:25 -0400
Received: by mail-qc0-f173.google.com with SMTP id c3so885899qcv.32
        for <linux-ext4@vger.kernel.org>; Fri, 13 Sep 2013 06:41:24 -0700 (PDT)
In-Reply-To: <20130912184732.GA28067@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 09/12/2013 02:47 PM, Theodore Ts'o wrote:
> On Thu, Sep 12, 2013 at 10:52:38AM -0500, Eric Sandeen wrote:
>> However, it seems a little odd to me that ext4 feels it necessary to issue
>> discards on blocks which have been fallocated but not written to, I'll have
>> to think about that part (doesn't really matter for your case, it's just a
>> curiosity).
> For fstrim, we issue discards based on blocks which are not in use
> according to the block allocation bitmap.
>
> It shouldn't matter that we've issued discard on blocks which had been
> previously discarded, and in fact, it might help, since sometimes
> storage devices only traces block usage on large granularities ---
> that is, it might only releases blocks on a thin provisioned storage
> when a full megabyte worth of blocks are discarded.
>
> 					- Ted
>

It is the right thing to do to re-issue the trims I think for exactly that 
reason. Devices are allowed by the spec to ignore requests that are not aligned 
to their needs, so this lets us try to get back in sync.

ric

