From: "Yan Zheng" <ukernel@gmail.com>
Subject: Why max_debt isn't used in ext4's find_group_orlov(...) ?
Date: Thu, 19 Jul 2007 21:00:46 +0800
Message-ID: <3d0408630707190600r3c630db8h3dcc6550e93cfb27@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
To: linux-ext4@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi all

max_debt is used in ext2's find_group_orlov .  In ext4's
find_group_orlov, max_debt is only computed, but not used.  I wonder
whether it's a typo,  Can anyone give me a answer? The kernel source I
read is 2.6.22.

Thanks in advance.

----------------
Best Regards

YZ
