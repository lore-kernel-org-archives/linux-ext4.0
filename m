From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [RFC] basic delayed allocation in VFS
Date: Thu, 26 Jul 2007 08:05:17 -0400
Message-ID: <46A88DFD.7030609@garzik.org>
References: <46A8628D.6070103@clusterfs.com> <46A87858.40005@garzik.org> <46A878FC.5040600@clusterfs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org,
	Christoph Hellwig <hch@infradead.org>
To: Alex Tomas <alex@clusterfs.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <46A878FC.5040600@clusterfs.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Alex Tomas wrote:
> Jeff Garzik wrote:
>> Is this based on Christoph's work?
>>
>> Christoph, or some other XFS hacker, already did generic delalloc, 
>> modeled on the XFS delalloc code.
> 
> nope, this one is simple (something I'd prefer for ext4).

The XFS one is proven and the work was already completed.

What were the specific technical issues that made it unsuitable for ext4?

I would rather not reinvent the wheel, particularly if the reinvention 
is less capable than the existing work.

	Jeff



