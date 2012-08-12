From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Upgraded from 3.4 to 3.5.1 kernel: machine does not boot
Date: Sun, 12 Aug 2012 10:36:01 -0400
Message-ID: <CAO9zADyDfysmwKL4s5ir=ko82oNK5=9M_x18RY2OVWrL5Ki_Bw@mail.gmail.com>
References: <0bac01cd7717$9fa6bbf0$def433d0$@lucidpixels.com>
	<alpine.LNX.2.00.1208101948590.17673@swampdragon.chaosbits.net>
	<CAO9zADxocKKFMsf5RqmP+YMjFLj58yDbdqFm1xexQ+mSLb7JHQ@mail.gmail.com>
	<0de101cd774c$fb2afa10$f180ee30$@lucidpixels.com>
	<CAO9zADzxste_Zs0CGtNoTL0SARV41-q4X-8i8fXBPVNQ4ADDcA@mail.gmail.com>
	<5027AB4A.6010200@sandeen.net>
	<CAO9zADxPQc9vqdhOeXj1Du=TeV_k5pRtBV9jyVLz-zk0bYFk_w@mail.gmail.com>
	<CAP=VYLoRosDjR-ciSP6cLwVtxy=Xf_k-RgkXHxfi=WLtxiaY7A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Eric Sandeen <sandeen@sandeen.net>, Jesper Juhl <jj@chaosbits.net>,
	linux-kernel@vger.kernel.org, ap@solarrain.com,
	linux-ext4@vger.kernel.org, greg@kroah.com
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:56783 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923Ab2HLOgC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 12 Aug 2012 10:36:02 -0400
Received: by obbuo13 with SMTP id uo13so5393798obb.19
        for <linux-ext4@vger.kernel.org>; Sun, 12 Aug 2012 07:36:01 -0700 (PDT)
In-Reply-To: <CAP=VYLoRosDjR-ciSP6cLwVtxy=Xf_k-RgkXHxfi=WLtxiaY7A@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Aug 12, 2012 at 10:13 AM, Paul Gortmaker
<paul.gortmaker@windriver.com> wrote:
> On Sun, Aug 12, 2012 at 9:51 AM, Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
>> On Sun, Aug 12, 2012 at 9:10 AM, Eric Sandeen <sandeen@sandeen.net> wrote:
>>> On 8/10/12 11:14 PM, Justin Piszcz wrote:
>>>> On Fri, Aug 10, 2012 at 7:07 PM, Justin Piszcz
>>>>>
>>>>> Hi,
>>>>>
>>>>> Found the root cause, the 3.5.1 kernel cannot mount my ext4 filesystem
>>>>> (60TB).
>>>
>>> You are a brave man running ext4 at 60T, but thank you for testing :)
>>>
>>> Backing out 8aeb00ff85ad25453765dd339b408c0087db1527 from 3.5.1
>>> (952fc18ef9ec707ebdc16c0786ec360295e5ff15 upstream) probably helps?
>>>
>>> From a quick look, I think that essentially has a :
>>>
>>> for (i = 0; i < ngroups; i++) {
>>>
>>>         for (j = 0; j < ngroups; j++) {
>>>
>>>         }
>>> }
>>>
>>> type nested loop going on; for a filesystem this big it's going to take almost
>>> literally forever, if I read it right.
>>>
>>> -Eric
>>
>> Hello,
>>
>> It worked!! I can mount my filesystem now!
>>
>> I pulled down 3.5 and backed out that commit, I could not quickly find
>> a doc to do this, so I will add how to do that below:
>>
>> 1. Clone Linux repo (3.5/stable as of this writing)
>> git clone git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git
>>
>> 2. List commits:
>> git log
>>
>> 3. Show a specific commit
>> git show 8aeb00ff85ad25453765dd339b408c0087db1527
>>
>> 4. How to revert the commit:
>> git revert 8aeb00ff85ad25453765dd339b408c0087db1527
>>
>> # On branch master
>> nothing to commit (working directory clean)
>
> You didn't actually revert anything here, because your clone left
> you on "master" branch, which points at 3.5 (i.e. 3.5.0).   It does
> not contain the commit which is of interest to you.
>
> -------------
> linux-stable$git tag --contains 8aeb00ff
> v3.5.1
> linux-stable$git branch --contains 8aeb00ff
>   linux-3.5.y
> linux-stable$
> ------------
>
> The master branch in linux-stable is left pointing at one of the
> most recent mainline (i.e. non-stable) tags, and all of the stable
> content is on individual branches (type "git branch" to see them).
>
> So if you do a "git checkout linux-3.5.y"  and then do the revert,
> you will actually be testing what you wanted to test.
>
> Paul.
> --

Yikes, I saw the git details (via get show) but that must check the
commit via git/inet-- I assumed that was also in the 3.5 tree, but its
not per your check, so I've made some changes to my notes, recompiled,
rebooted .. and success!!  Woohoo!

One other item, I've never used a git updated kernel before, usually
just patch -p1 the mainline or pull it down directly (but git seems
nicer now that I know how to do it), does the '+' signify its the
3.5.1 kernel and then a '+' because I made changes to it?

p34:~# df -h | grep /r1
/dev/sda1        61T   16T   45T  26% /r1
p34:~# uname -a
Linux p34 3.5.1+ #3 SMP Sun Aug 12 10:31:34 EDT 2012 x86_64 GNU/Linux
p34:~# uptime
 10:35:12 up 1 min,  1 user,  load average: 0.05, 0.03, 0.01
p34:~#

---


Updated notes:


1. Clone Linux repo (3.5/stable as of this writing)
git clone git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git
linux-3.5

2.0 Cd into linux-3.5
cd linux-3.5

2.1 Check available kernel versions:
git tag | tail -n 3
v3.5-rc6
v3.5-rc7
v3.5.1

2.2 Update to the latest 3.5.1 kernel:
git checkout linux-3.5.1

Note: checking out 'v3.5.1'.
..
HEAD is now at cbd3c20... Linux 3.5.1

2.3 Confirm it is 3.5.1:
# head -n 3 Makefile
VERSION = 3
PATCHLEVEL = 5
SUBLEVEL = 1

2.4 List commits:
git log

3. Show a specific commit
git show 8aeb00ff85ad25453765dd339b408c0087db1527

4. How to revert the commit:
git revert 8aeb00ff85ad25453765dd339b408c0087db1527
(It brings up a text editor like svn/cvs, commit -> write/save/quit)

[detached HEAD 35d699f] Revert "ext4: fix overhead calculation used by
ext4_statfs()"
 Committer: root <root@lucidpixels.com>
Your name and email address were configured automatically based
on your username and hostname. Please check that they are accurate.
You can suppress this message by setting them explicitly:

    git config --global user.name "Your Name"
    git config --global user.email you@example.com

After doing this, you may fix the identity used for this commit with:

    git commit --amend --reset-author

 4 files changed, 57 insertions(+), 132 deletions(-)

5. Recompile, reboot, does it work, still?
# df -h
Filesystem      Size  Used Avail Use% Mounted on
/dev/sda1        61T   17T   44T  28% /r1
# uname -a
Linux p34 3.5.0 #1 SMP Sun Aug 12 09:42:41 EDT 2012 x86_64 GNU/Linux

Yes!


--

How to find where a particular commit lies?

-------------
linux-stable$git tag --contains 8aeb00ff
v3.5.1
linux-stable$git branch --contains 8aeb00ff
  linux-3.5.y
linux-stable$

--

Justin.
