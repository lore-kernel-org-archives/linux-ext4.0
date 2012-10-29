From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFC v4+ hot_track 00/19] vfs: hot data tracking
Date: Mon, 29 Oct 2012 03:30:19 -0700
Message-ID: <m2boflr2o4.fsf@firstfloor.org>
References: <1351485061-12297-1-git-send-email-zwu.kernel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	linuxram@linux.vnet.ibm.com, viro@zeniv.linux.org.uk,
	david@fromorbit.com, tytso@mit.edu, cmm@us.ibm.com,
	wuzhy@linux.vnet.ibm.com, wenqing.lz@taobao.com
To: zwu.kernel@gmail.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1351485061-12297-1-git-send-email-zwu.kernel@gmail.com> (zwu
	kernel's message of "Mon, 29 Oct 2012 12:30:42 +0800")
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

zwu.kernel@gmail.com writes:
>
> TODO List:
>
>  1.) Need to do scalability or performance tests.

You're changing some of the most performance critical code in the
kernel. This step is absolutely not optional.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
