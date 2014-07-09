From: Namjae Jeon <namjae.jeon@samsung.com>
Subject: RE: [PATCH 2/3] xfs: Add support IOC_MOV_DATA ioctl
Date: Wed, 09 Jul 2014 15:33:21 +0900
Message-ID: <001801cf9b3f$ad786ff0$08694fd0$@samsung.com>
References: <003f01cf9aa4$1e9e5240$5bdaf6c0$@samsung.com>
	<20140708121500.GA518@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: 'Theodore Ts'o' <tytso@mit.edu>, 'Brian Foster' <bfoster@redhat.com>,
	linux-kernel@vger.kernel.org, xfs@oss.sgi.com,
	'Ashish Sangwan' <a.sangwan@samsung.com>, linux-fsdevel@vger.kernel.org,
	'Luk?? Czerner' <lczerner@redhat.com>,
	'linux-ext4' <linux-ext4@vger.kernel.org>
To: 'Christoph Hellwig' <hch@infradead.org>
Return-path: <xfs-bounces@oss.sgi.com>
In-reply-to: <20140708121500.GA518@infradead.org>
Content-language: ko
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
List-Id: linux-ext4.vger.kernel.org

> 
> On Tue, Jul 08, 2014 at 08:59:49PM +0900, Namjae Jeon wrote:
> > This patch implements fs ioctl's IOC_MOV_DATA for XFS.
> 
> Shouldn't this share code with the XFS_IOC_SWAPEXT implementation?
Lukas has raised the same question for ext4.
Both xfs(XFS_IOC_SWAPEXT) and ext4(EXT4_IOC_MOVE_EXT) has ioctls which uses
almost similar kind of structure as struct mov_data.
As such, there seems to be possiblity for sharing basic code (I will try)
used for sanity checking in IOC_MOV_DATA to be shared with these ioctls
but the core functionality code will remain different.

Thanks!

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
