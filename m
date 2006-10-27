From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [RFC] Ext3 online defrag
Date: Fri, 27 Oct 2006 08:53:58 -0500
Message-ID: <45420F76.90106@redhat.com>
References: <20061027162326sho@rifu.tnes.nec.co.jp> <m3lkn2ryno.fsf@bzzz.home.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: sho@tnes.nec.co.jp, tytso@mit.edu, jack@suse.cz,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
To: Alex Tomas <alex@clusterfs.com>
In-Reply-To: <m3lkn2ryno.fsf@bzzz.home.net>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Alex Tomas wrote:
> 3) scalable reservation
>    required for delayed allocation to avoid -ENOSPC at flush time.
>    current version uses per-sb spinlock.

Can you elaborate on this issue?  Shouldn't delayed allocation decrement free 
space immediately, and only the actual block location choice is delayed?  Or is 
this due to potential extra metadata space required as blocks are allocated?

Thanks,

-Eric
