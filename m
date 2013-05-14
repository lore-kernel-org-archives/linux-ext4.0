From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: EXT4 regression caused 4eec7
Date: Tue, 14 May 2013 09:08:13 -0500
Message-ID: <5192454D.5030805@redhat.com>
References: <6719519.5821368147110937.JavaMail.weblogic@epml17> <20130510192747.GA11707@thunk.org> <87y5bm53z3.fsf@openvz.org> <87txm96fkd.fsf@openvz.org> <87mws1eq6y.fsf@openvz.org> <20130511230559.GD26298@thunk.org> <87a9o01siw.fsf@openvz.org> <51911604.2060805@redhat.com> <20130513170124.GJ400@quack.suse.cz> <51911E42.7010008@redhat.com> <874ne6xcgr.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>, "Theodore Ts'o" <tytso@mit.edu>,
	EUNBONG SONG <eunb.song@samsung.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <874ne6xcgr.fsf@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 5/14/13 2:11 AM, Dmitry Monakhov wrote:
> On Mon, 13 May 2013 12:09:22 -0500, Eric Sandeen <sandeen@redhat.com> wrote:
>> On 5/13/13 12:01 PM, Jan Kara wrote:
>>> On Mon 13-05-13 11:34:12, Eric Sandeen wrote:
>>>> On 5/12/13 4:01 AM, Dmitry Monakhov wrote:
>>>>> In fact '4eec70' are vexing because I have reviewed and tested this patch before
>>>>> it was marked as Review-by, but missed the bug. This is because xfstests
>>>>> was executed manually logs was full of warnings but tainted flag was not
>>>>> checked at the end. 
>>>>
>>>> Can you elaborate on this?  What was logged, and is it something we could
>>>> try to pick up post-test in xfstests?
>>>   Generally I think it might be useful if xfstests would fail / warn if
>>> kernel became tainted during the test (e.g. due to WARN_ON or oops, or
>>> something like that). It should be even relatively easy to implement
>>> (just compare /proc/sys/kernel/tainted before and after each test).
>>>
>>> 								Honza
>>>
>>
>> Ah, right.  That should be easy, I'll see if I can cook that up.
> Also we can use abrt's kernel-oops handler to collect messages.

I sent a pretty simple patch to just check the sysctl to the xfs list
yesterday.

-Eric
