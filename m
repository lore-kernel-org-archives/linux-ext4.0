From: Alex Xu <alex_y_xu@yahoo.ca>
Subject: Re: bfq/ext4 disk IO hangs forever on resume
Date: Fri, 18 Aug 2017 16:29:20 -0400
Message-ID: <20170818162920.6bd377ad.alex_y_xu@yahoo.ca>
References: <20170625230756.68b4de21.alex_y_xu@yahoo.ca>
        <CACVXFVNA+Wk+zL_yDEzxAwjC_vOeFBNa40s5mCAEG5w4v7ftTg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:EXT4 FILE SYSTEM" <linux-ext4@vger.kernel.org>
To: Ming Lei <tom.leiming@gmail.com>, Jens Axboe <axboe@kernel.dk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CACVXFVNA+Wk+zL_yDEzxAwjC_vOeFBNa40s5mCAEG5w4v7ftTg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 25 Jul 2017 20:18:07 +0800
Ming Lei <tom.leiming@gmail.com> wrote as excerpted:

> On Mon, Jun 26, 2017 at 11:07 AM, Alex Xu <alex_y_xu@yahoo.ca> wrote:
> > Hi,
> >
> > I get hangs when resuming when using bfq-mq with ext4 on 4.12-rc6+
> > (currently a4fd8b3accf43d407472e34403d4b0a4df5c0e71).  
> 
> Please test the following patch to see if it can help your issue:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git/commit/?h=for-linus&id=765e40b675a9566459ddcb8358ad16f3b8344bbe
> 

I tried 4.13-rc3+ (including that commit) and still have (seemingly)
the same issue.
