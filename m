From: "Takashi Sato" <t-sato@yk.jp.nec.com>
Subject: Re: [PATCH 3/3] Add timeout feature
Date: Thu, 9 Oct 2008 19:12:17 +0900
Message-ID: <0AD458D29A8E4938BB3914BB5C562C39@nsl.ad.nec.co.jp>
References: <20080908205337t-sato@mail.jp.nec.com>
	<20080908171119.GB22521@infradead.org>
	<48DBFD42.6030307@redhat.com>
	<D0B0D91F884647D6808626CDFF81E532@nsl.ad.nec.co.jp>
	<20080929141326.GA31781@infradead.org>
	<48E0E7D4.1090409@sandeen.net>
	<20080929143749.GA13286@infradead.org>
	<48E0EA0B.7000701@sandeen.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Cc: axboe@kernel.dk, mtk.manpages@googlemail.com, linux-kernel@vger.kernel.org,
	xfs@oss.sgi.com, dm-devel@redhat.com, viro@ZenIV.linux.org.uk,
	linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org, Ric Wheeler <rwheeler@redhat.com>,
	Oleg Nesterov <oleg@tv-sign.ru>
To: "Eric Sandeen" <sandeen@sandeen.net>,
	"Christoph Hellwig" <hch@infradead.org>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <48E0EA0B.7000701@sandeen.net>
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

Eric Sandeen wrote:
> Christoph Hellwig wrote:
>> On Mon, Sep 29, 2008 at 09:36:04AM -0500, Eric Sandeen wrote:
>>> Christoph Hellwig wrote:
>>>> On Fri, Sep 26, 2008 at 05:52:35PM +0900, Takashi Sato wrote:
>>>>> I think that your concern is that the freezer cannot recognize the occurrence
>>>>> of a timeout and it continues the backup process and the backup data is
>>>>> corrupted finally.
>>>> What timeout should happen?  the freeze ioctl must not return until the
>>>> filesystem is a clean state and all writes are blocked.
>>> The suggestion was that *UN*freeze would return ETIMEDOUT if the
>>> filesystem had already unfrozen itself, I think.  That way you know that
>>> the snapshot you just took is worthless, at least.
>>
>> But why would the filesystem every unfreeze itself?  That defeats the
>> whole point of freezing it.
>
> I agree.  Was just trying to clarify the above point.
>
> But there have been what, 12 submissions now, with the unfreeze timeout
> in place so it's a persistent theme ;)
>
> Perhaps a demonstration of just how easy (or not easy) it is to deadlock
> a filesystem by freezing the root might be in order, at least.
>
> And even if it is relatively easy, I still maintain that it is the
> administrator's role to not inflict damage on the machine being
> administered.  There are a lot of potentially dangerous tools at root's
> disposal; why this particular one needs a nanny I'm still not quite sure.

I think we need the timeout for the case someone dirties so much data
with mmap, hence the freeze process is swapped out and cannot unfreeze.

Cheers, Takashi
