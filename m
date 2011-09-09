From: Eric Whitney <eric.whitney@hp.com>
Subject: 3.1-rc2 and 3.0 filesystem scalability measurements
Date: Fri, 09 Sep 2011 19:35:58 -0400
Message-ID: <4E6AA2DE.2060903@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

(Several filesystem developers have asked that I post this on the 
fsdevel as well the ext4 mailing lists.)

I've posted the results of some 3.1-rc2 / 3.0 ext4 scalability 
measurements and comparisons on a 48 core x86_64 server at:

http://free.linux.hp.com/~enw/ext4/3.1-rc2

This includes throughput and CPU efficiency graphs for five simple 
workloads, the raw data for same, and lockstats as well.  The data have 
been useful in improving ext4 scalability in the past.

The data cover ext4 filesystems with and without journals.  For 
reference, ext3, xfs, and btrfs are included as well.

The most notable improvement in this data is a significant scalability 
gain for xfs when running the large_file_creates workload (the lockstats 
suggest a behavioral change).  This was first visible in 3.1-rc1.  ext4 
remains relatively unchanged.

Dave Chinner has asked that I make some changes to the way I collect xfs 
data, and I'll try to address those before I post again.

Thanks,
Eric
