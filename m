From: Yehuda Sadeh Weinraub <yehuda.sadeh@dreamhost.com>
Subject: Re: ceph and ext4
Date: Sun, 12 Feb 2012 11:50:23 -0800
Message-ID: <CAC-hyiHRtfJ2QUcxp4_g75f8cY9R3qAgwNv8C5Z_J5eFG8t2Zw@mail.gmail.com>
References: <4EC10664.1080501@tuxadero.com>
	<CAO47_-9nfO32nwOAQMVdqw6iWGWK+FWb+MD=WeOz_vr4YrrKmw@mail.gmail.com>
	<20111115142246.GA7516@thunk.org>
	<246EA1CC-3C33-4D41-80C0-2331C426EBB0@whamcloud.com>
	<CAO47_-9vGg89HgxjT=dzSSsUxxdbZ=yJoYQk4Qge8WGPjeVmKw@mail.gmail.com>
	<5D6C7B37-1594-48FF-A682-8CC1FE0A6870@whamcloud.com>
	<CAC-hyiEUGoXSmtRnk8Y5GoEzLfjhWqEJbqXT_MXbn6OVuSj36Q@mail.gmail.com>
	<5B8CFFA2-F95F-4CE4-9DE0-5D757BB17B81@whamcloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: chb@muc.de,
	"ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Jian Yu <yujian@whamcloud.com>
To: Andreas Dilger <adilger@whamcloud.com>
Return-path: <ceph-devel-owner@vger.kernel.org>
In-Reply-To: <5B8CFFA2-F95F-4CE4-9DE0-5D757BB17B81@whamcloud.com>
Sender: ceph-devel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun, Feb 12, 2012 at 9:18 AM, Andreas Dilger <adilger@whamcloud.com>=
 wrote:
> On 2012-02-11, at 9:05 PM, Yehuda Sadeh Weinraub wrote:
>> On Fri, Dec 9, 2011 at 2:24 PM, Andreas Dilger <adilger@whamcloud.co=
m> wrote:
>>>
>>> On 2011-12-08, at 3:59 PM, Christian Brunner wrote:
>>>> 2011/11/15 Andreas Dilger <adilger@whamcloud.com>:
>>>>> Coincidentally, we have someone working in those patches again. T=
he main obstacle for accepting the previous patch as-is was that Ted wa=
nted to add support for "medium-sized" xattrs that are addressed as a s=
tring of blocks, instead of via an inode.
>>>>
>>>> Did you make progress with this. I'm still having serious trouble =
with
>>>> btrfs and would like to try these.
>>>
>>> The latest patches are available at http://review.whamcloud.com/170=
8, but are based on the RHEL6.1 2.6.32 kernel. =A0The work to implement=
 "medium-sized" xattrs was more complex than anticipated, and is not fi=
nished yet.
>>>
>>> The use of external inode xattrs is working, which allows xattr siz=
es up to 64kB. =A0The 64kB limit is imposed by the VFS and could potent=
ially be increased.
>>
>> I was able to get those compile on a recent kernel.
>
> It would be useful if you could send me the updated patch, if there w=
ere
> any significant changes.

I pushed it to the the ext4-large-xattr branch, here:

https://github.com/NewDreamNetwork/ceph-client.git

>
>> One issue that I
>> see is that it will only use a separate inode for the xattr if the
>> xattr is big enough. However, it may be that we ran out of enough
>> space to set a smaller xattr, and in that case we would fail setting
>> it even though we'd be able to set a larger xattr.
>> Another related issue, is that the number of xattrs that can be used
>> is still limited (by what can be indexed in a single block?).
>
> That is true with the current patch. =A0When the "medium sized" xattr=
s are
> finished, then there will be 64kB of space for xattrs in the external
> block(s), which could be both xattr headers and data.

Is there any progress with this feature? Is there any public
repository where we can take a look at that?

Thanks,
Yehuda
--
To unsubscribe from this list: send the line "unsubscribe ceph-devel" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
