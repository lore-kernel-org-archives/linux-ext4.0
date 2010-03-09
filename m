From: jim owens <owens6336@gmail.com>
Subject: Re: defrag deployment status (was Re: [PATCH] ext4: allow defrag
 	(EXT4_IOC_MOVE_EXT) in 32bit compat mode)
Date: Tue, 09 Mar 2010 08:23:09 -0500
Message-ID: <4B964BBD.3070707@gmail.com>
References: <201003072132.10579.borntraeger@de.ibm.com>	 <4B94367E.9080506@garzik.org>	 <201003080853.42978.borntraeger@de.ibm.com>	 <4B9518DA.8010201@davidnewall.com> <4B952437.8020607@gmail.com> <87f94c371003080831n4d310e10i2b9badf4290f1ede@mail.gmail.com> <4B952FB5.2060600@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: David Newall <davidn@davidnewall.com>,
	Christian Borntraeger <borntraeger@de.ibm.com>,
	Jeff Garzik <jeff@garzik.org>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, Akira Fujita <a-fujita@rs.jp.nec.com>
To: Greg Freemyer <greg.freemyer@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4B952FB5.2060600@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

After thinking about it overnight, I realized I think in terms
of 1 drive is 1 filesystem.  That is a fatal trap for defragment.
 
> When I only worried about a few OEM drives, I used to read the zone
> geometry from the drive to see where each speed transition was as the
> density decreased.  But that is just not worth the effort in linux
> filesystems IMO, it is enough to pack low.

So I retract that we don't care about zone geometry, we need to
care deeply, but not in the sense of how moving short distances
on a drive affects the performance.  What we need to ensure is
that the placer algorithm does not span across partitions as in:

["/" 100GB created] [300GB other] [100G LVM added to "/"]

so the filesystem thinks it is 200GB contiguous and the
defragmenter thinks address 90GB is closer to address 110 GB
than 90GB is to 50GB.

jim
