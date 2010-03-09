From: David Newall <davidn@davidnewall.com>
Subject: Re: defrag deployment status (was Re: [PATCH] ext4: allow defrag
 (EXT4_IOC_MOVE_EXT) in 32bit compat mode)
Date: Wed, 10 Mar 2010 02:49:41 +1030
Message-ID: <4B96751D.10804@davidnewall.com>
References: <201003072132.10579.borntraeger@de.ibm.com> <4B94367E.9080506@garzik.org> <201003080853.42978.borntraeger@de.ibm.com> <4B9518DA.8010201@davidnewall.com> <4B952437.8020607@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
	Jeff Garzik <jeff@garzik.org>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, Akira Fujita <a-fujita@rs.jp.nec.com>
To: jim owens <owens6336@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4B952437.8020607@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

jim owens wrote:
> No.  Your logic would be correct if rotating disks had
> similar speed at all locations.  Current disks are much
> faster at the 0 end than at the middle or highest address.
>   

I think  my logic is still correct, although I wished I had said "closer 
to the middle."  In fact, simplistic ideas for placement of files are 
unlikely to produce fabulous results (and that includes placing commonly 
used files towards the middle of the disk, say at the inside edge of the 
outermost zone.)  The effort that BSD went to in FFS, placing 
directories with files and meta-data in cylinder groups, illustrates 
that disk performance is a sophisticated problem.

Why don't we use BSD FFS/FFS2?
