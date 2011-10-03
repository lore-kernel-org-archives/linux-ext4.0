From: =?UTF-8?B?UMOhZHJhaWcgQnJhZHk=?= <P@draigBrady.com>
Subject: Re: [BUG] copy file result with zero
Date: Mon, 03 Oct 2011 12:08:58 +0100
Message-ID: <4E8997CA.7060404@draigBrady.com>
References: <CABqxG0feuZCmx=RfxU-50uFK9-P2vNbAMqJUdWM5RhuJifD5Ow@mail.gmail.com>
	<20111001143900.GH28234@thunk.org>
	<CABqxG0eiRiCSirXi5rBB0bJ2AJSQjF2dje2BcjbVYEYWgf-zpw@mail.gmail.com>
	<A2FF8835-2386-47F9-AFF8-4E09BEC4F80E@oracle.com>
	<CA140AD1-B715-46BF-81B3-EA2069CBC131@dilger.ca>
	<CABqxG0eMarBn_8xHCOZPq3pae4K01C51Rmxdox7uZr0gWOHGGw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: Andreas Dilger <aedilger-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Coreutils <coreutils-mXXj517/zsQ@public.gmane.org>, Ted Ts'o <tytso-3s7WtUTddSA@public.gmane.org>,
	linux-ext4 development <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Dave Young <hidave.darkstar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <coreutils-bounces+gcgcg-coreutils=m.gmane.org-mXXj517/zsQ@public.gmane.org>
In-Reply-To: <CABqxG0eMarBn_8xHCOZPq3pae4K01C51Rmxdox7uZr0gWOHGGw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Unsubscribe: <https://lists.gnu.org/mailman/options/coreutils>,
	<mailto:coreutils-request-mXXj517/zsQ@public.gmane.org?subject=unsubscribe>
List-Archive: </archive/html/coreutils>
List-Post: <mailto:coreutils-mXXj517/zsQ@public.gmane.org>
List-Help: <mailto:coreutils-request-mXXj517/zsQ@public.gmane.org?subject=help>
List-Subscribe: <https://lists.gnu.org/mailman/listinfo/coreutils>,
	<mailto:coreutils-request-mXXj517/zsQ@public.gmane.org?subject=subscribe>
Errors-To: coreutils-bounces+gcgcg-coreutils=m.gmane.org-mXXj517/zsQ@public.gmane.org
Sender: coreutils-bounces+gcgcg-coreutils=m.gmane.org-mXXj517/zsQ@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On 10/02/2011 09:43 AM, Dave Young wrote:
> On Sun, Oct 2, 2011 at 4:02 PM, Andreas Dilger <aedilger-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> On 2011-10-01, at 11:41 PM, Jeff liu wrote:
>>>> On Sat, Oct 1, 2011 at 10:39 PM, Ted Ts'o <tytso-3s7WtUTddSA@public.gmane.org> wrote:
>>>>> On Sat, Oct 01, 2011 at 10:01:35PM +0800, Dave Young wrote:
>>>>>> Weird problem, when I build app from source,
>>>>>> make; make install
>>>>>> run the command, but got "cannot execute binary file"
>>>>>>
>>>>>> hexdump shows the installed binary is full of zero
>>>>>>
>>>>>> Is it related to ext4 fiemap problem described below?
>>>>>> http://lwn.net/Articles/429349/
>>>>>
>>>>> There is general agreement that /bin/cp should not have been relying
>>>>> on FIEMAP, and I believe the more recent versions of /bin/cp have
>>>>> removed that code by default pending implementation of
>>>>> SEEK_HOLE/SEEK_DATA.  That being said, ext4 had a workaround to its
>>>>> FIEMAP implementation that landed in 2.6.39, and you're using
>>>>> 3.1.0-rc6.
>>>
>>> Actually, upstream cp(1) using FIEMAP only if the source file is sparse,  or else, it will do normal copy, i.e, block based.
>>
>> Are there any distros that are shipping with a version of cp that depends on FIEMAP?  That would dramatically increase the severity of this problem, since orders of magnitude more users will hit the problem.
> 
> I'm not sure if it depends on FIEMAP, I think it should be not so old.
> 
>>
>> Dave, what distro were you seeing this problem on, and had you installed/upgraded your coreutils and/or kernel yourself?
> 
> Slackware 13.37, coreutils 8.11
> kernel is always built from linus's git by myself

Coreutils 8.11 was only released for 13 days,
before 8.12 was released specifically to avoid this issue.
Slackware should update.

Coreutils 8.12 only uses a fiemap based copy for
sparse files, where it will do a sync first.
The sparseness heuristic is st_blocks < st_size / st_blksize

cheers,
Pádraig.
