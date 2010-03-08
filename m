From: David Newall <davidn@davidnewall.com>
Subject: Re: defrag deployment status (was Re: [PATCH] ext4: allow defrag
 (EXT4_IOC_MOVE_EXT) in 32bit compat mode)
Date: Tue, 09 Mar 2010 02:03:46 +1030
Message-ID: <4B9518DA.8010201@davidnewall.com>
References: <201003072132.10579.borntraeger@de.ibm.com> <4B94367E.9080506@garzik.org> <201003080853.42978.borntraeger@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jeff Garzik <jeff@garzik.org>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, Akira Fujita <a-fujita@rs.jp.nec.com>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <201003080853.42978.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Christian Borntraeger wrote:
> Some bigger things are missing in the e4defrag tool:
> ...
> - overall layout considerations (e.g. putting files close to its directory or
>   use the atime to move often used files to the beginning of a disk etc.)

Shouldn't oft-used files be placed closer to the middle?  If you place 
them at the beginning of the file, it's only possible for the head-stack 
to be close to the file from the inner direction.  Place them in the 
middle and it's possible for the head-stack to be close from the outer 
direction, too, which sounds like a doubling of probability.  It seems 
that it's the least frequently used files that should be placed at one 
end of the disk or the other.
