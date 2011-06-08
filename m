From: Sunil Mushran <sunil.mushran@oracle.com>
Subject: Re: LVM vs. Ext4 snapshots (was: [PATCH v1 00/30] Ext4 snapshots)
Date: Wed, 08 Jun 2011 11:49:31 -0700
Message-ID: <4DEFC43B.1080802@oracle.com>
References: <BANLkTimyBGfg4+ovGsiGqpCz345qVmU_7A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Mike Snitzer <snitzer@redhat.com>,
	Lukas Czerner <lczerner@redhat.com>,
	linux-ext4@vger.kernel.org, tytso@mit.edu,
	linux-kernel@vger.kernel.org, sandeen@redhat.com
To: "Amir G." <amir73il@users.sourceforge.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <BANLkTimyBGfg4+ovGsiGqpCz345qVmU_7A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 06/08/2011 11:26 AM, Amir G. wrote:
> 2. Data blocks are never copied
> The move-on-write technique is used to re-allocate data blocks on rewrite
> instead of copying them.
> This is not something that can be done when the snapshot is stored on
> external storage, but it can done when the snapshot file lives in the fs.

But does that not lead to fragmentation. And if I am understanding this,
the fragmentation will not resolve after dropping the snapshot. So while
you do save the overhead on write, you make the user pay on all future
reads (that need to hit the disk).
