From: Jeff Garzik <jeff@garzik.org>
Subject: Re: Is TRIM/DISCARD going to be a performance problem?
Date: Mon, 11 May 2009 11:43:44 -0400
Message-ID: <4A0847B0.1070507@garzik.org>
References: <E1M2ts6-0005jr-Cg@closure.thunk.org> <20090510165259.GA31850@logfs.org> <20090511083754.GA29082@mit.edu> <20090511100624.GB6585@logfs.org> <20090511101815.GR4694@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: =?ISO-8859-1?Q?J=F6rn_Engel?= <joern@logfs.org>,
	Theodore Tso <tytso@mit.edu>,
	Matthew Wilcox <willy@linux.intel.com>,
	Ric Wheeler <rwheeler@redhat.com>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20090511101815.GR4694@kernel.dk>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Jens Axboe wrote:
>>> The only problem with SSD's is the people who designed the ATA TRIM
>>> command requires us to completely drian the I/O queue before issuing
>>> it.  Because of this incompetence, we need to be a bit more careful
>>> about how we issue them.
>> And this bit that I wasn't aware of.  Such a requirement in the standard
>> is a trainwreck indeed.
> 
> Precisely, but that's how basically anything works with SATA NCQ, only
> read/write dma commands may be queued. Anything else requires an idle
> drive before issue.

Very true -- but FWIW, one option being considered at T13 is having a 
queue-able TRIM.

	Jeff


