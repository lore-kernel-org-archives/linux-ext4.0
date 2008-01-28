From: "Takashi Sato" <t-sato@yk.jp.nec.com>
Subject: Re: [RFC] ext3 freeze feature
Date: Mon, 28 Jan 2008 22:13:05 +0900
Message-ID: <01cb01c861af$8515d230$41a8400a@bsd.tnes.nec.co.jp>
References: <20080125195938t-sato@mail.jp.nec.com> <20080125121851.GA3361@dmon-lap.sw.ru> <20080125133329.GB8184@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Cc: <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
	<linux-ext4@vger.kernel.org>
To: "Theodore Tso" <tytso@MIT.EDU>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi,

> What you *could* do is to start putting processes to sleep if they
> attempt to write to the frozen filesystem, and then detect the
> deadlock case where the process holding the file descriptor used to
> freeze the filesystem gets frozen because it attempted to write to the
> filesystem --- at which point it gets some kind of signal (which
> defaults to killing the process), and the filesystem is unfrozen and
> as part of the unfreeze you wake up all of the processes that were put
> to sleep for touching the frozen filesystem.

I don't think close() usually writes to journal and the deadlock occurs.
Is there the special case which close() writes to journal in case of
getting signal?

Cheers, Takashi 

