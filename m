From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] x86_64/lib: improve the performance of memmove
Date: Thu, 16 Sep 2010 12:11:41 +0200
Message-ID: <20100916121141.6eb95a22@basil.nowhere.org>
References: <56957.91.60.149.91.1284619705.squirrel@www.firstfloor.org>
	<4C91C44F.40700@cn.fujitsu.com>
	<20100916104008.3e1e34b2@basil.nowhere.org>
	<4C91E37C.2060309@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Ingo Molnar <mingo@elte.hu>, "Theodore Ts'o" <tytso@mit.edu>,
	Chris Mason <chris.mason@oracle.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>,
	Linux Ext4 <linux-ext4@vger.kernel.org>
To: miaox@cn.fujitsu.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4C91E37C.2060309@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, 16 Sep 2010 17:29:32 +0800
Miao Xie <miaox@cn.fujitsu.com> wrote:


Ok was a very broken patch. Sorry should have really done some more
work on it. Anyways hopefully the corrected version is good for
testing.

-Andi


-- 
ak@linux.intel.com -- Speaking for myself only.
