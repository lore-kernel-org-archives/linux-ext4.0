From: Rich Johnston <rjohnston@sgi.com>
Subject: Re: [PATCH] xfstests: fix seek_sanity_test for fs w/o fallocate
Date: Fri, 31 May 2013 14:02:38 -0500
Message-ID: <51A8F3CE.4030801@sgi.com>
References: <51A8C59B.3030308@redhat.com> <20130531172456.GB6915@gmail.com>
	<51A8DACB.2030806@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <xfs-bounces@oss.sgi.com>
In-Reply-To: <51A8DACB.2030806@redhat.com>
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

On 05/31/2013 12:15 PM, Eric Sandeen wrote:
> On 5/31/13 12:24 PM, Zheng Liu wrote:
>> On Fri, May 31, 2013 at 10:45:31AM -0500, Eric Sandeen wrote:
>>> currently the seek_sanity_test (generic/285) fails on ext3
>>> or ext2 due to fallocate() failures.  Just ignore that test
>>> if the fs doesn't support fallocate.
>>
>> Hi Eric,
>>
>> I remember that my patch had been applied [1].  But stranger I couldn't
>> find it in xfstests tree.  However, I think that your patch is better.
>>
>> 1. http://oss.sgi.com/archives/xfs/2013-05/msg00534.html
>
> Oh, right, I had forgotten about that.  Rich, any idea?

No other than it was a Friday.  My apologies Zheng.
Zheng as your's should have been committed, what do you want me to do?

--Rich

>
> I don't care which patch goes in....
>
> -Eric
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
