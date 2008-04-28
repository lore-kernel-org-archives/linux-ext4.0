From: "Takashi Sato" <t-sato@yk.jp.nec.com>
Subject: Re: [RFC PATCH 1/3] Implement generic freeze feature
Date: Mon, 28 Apr 2008 21:59:55 +0900
Message-ID: <2E042A67F72447F6AAA0CC0605DBFA84@nsl.ad.nec.co.jp>
References: <20080428193123t-sato@mail.jp.nec.com>
	<20080428103719.GA16030@infradead.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org, dm-devel@redhat.com,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com
To: "Christoph Hellwig" <hch@infradead.org>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20080428103719.GA16030@infradead.org>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
List-Id: linux-ext4.vger.kernel.org

Hi,

> On Mon, Apr 28, 2008 at 07:31:23PM +0900, Takashi Sato wrote:
>> + /* Initialize semaphore for freeze. */
>> + sema_init(&bdev->bd_freeze_sem, 1);
>
> The freezing process is already protected by bd_mount_sem, so I don't
> think there's need for another one.
>
[...]
>>  down(&bdev->bd_mount_sem);
>>  sb = get_super(bdev);
>
> I think the protection against double freezes would be better done by
> using a trylock on bd_mount_sem.

bd_mount_sem can protect against only freezes and cannot protect against
unfreezes.  If multiple unfreezes run in parallel,  the multiple up() for
bd_mount_sem might occur incorrectly.

> In fact after that it could be changed
> from a semaphore to a simple test_and_set_bit.

I will consider using test_and_set_bit.

>>  error = -ENOTTY;
>>  break;
>> +
>> + case FIFREEZE: {
>
> This would be better to split intot a small helper ala ioctl_fibmap()
>
>> + case FITHAW: {
>
> Same here.

OK.  I will split small helper functions.

Cheers, Takashi 
