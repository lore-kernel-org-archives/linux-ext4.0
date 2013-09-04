From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: e2fsprogs - possible regression between 1.42.7 and 1.42.8
Date: Wed, 04 Sep 2013 09:02:09 -0500
Message-ID: <52273D61.7040609@redhat.com>
References: <20130729083941.GG28871@pcnci.linuxbox.cz> <51F694B6.90901@redhat.com> <51F87075.2020508@redhat.com> <51F8722D.9050707@redhat.com> <20130904080444.GP5953@pcnci.linuxbox.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:63114 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760161Ab3IDOCM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 4 Sep 2013 10:02:12 -0400
In-Reply-To: <20130904080444.GP5953@pcnci.linuxbox.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 9/4/13 3:04 AM, Nikola Ciprich wrote:
> Hello Eric,
> 
> I'm very sorry for such a late reply, I was a bit busy with other
> projects.. Well, I don't really understand what I should do with the
> images now :) But if I understand previous discussion well, my problem
> is not caused by code regressions, but new tests which were added
> to this new version right? The problems failed tests report are related
> to filesystems with 1K block size, so unless I use such filesystems,
> I'm safe to skip tests and use this new version, especially since I've
> been using 1.42.7 till now, right?
> 
> Or is there some git commit fixing those issues I should try?
> 
> Thanks a lot for Your time and sorry about my lame questions..

Nah, not lame.  To be honest, I've lost track of which resize2fs
bugs are fixed and which are not; some have been sent to the list,
some have not been fixed, and the e2fsprogs git tree hasn't been updated
for over 2 months.  So I'm really not sure where things stand right now.  :(

In any case, I don't _think_ that this particular bug is yet fixed.

- -Eric

> with best regards
> 
> nikola ciprich
> 
> 
> On Tue, Jul 30, 2013 at 09:10:53PM -0500, Eric Sandeen wrote:
> On 7/30/13 9:03 PM, Eric Sandeen wrote:
>>>> On 7/29/13 11:13 AM, Eric Sandeen wrote:
>>>>> On 7/29/13 3:39 AM, Nikola Ciprich wrote:
>>>>>> Hi,
>>>>
>>>>>> trying to compile latest e2fsprogs and running check under RHEL6-compatible
>>>>>> distro (centos) fails:
>>>>
>>>>>> r_1024_small_bg: ext2 1024 blocksize with small block groups: failed
>>>>>> r_ext4_small_bg: ext4 1024 blocksize with small block groups: failed
>>>>
>>>>>> dunno whether this is known issue... will bisect help?
>>>>
>>>>>> with regards
>>>>
>>>>>> nik
>>>>
>>>>
>>>>> Ted, these are the same ones I saw, plus one I think (working on getting
>>>>> all the info).
>>>>
>>>> Sorry this took a while.  Attached is a qcow image of a broken r_1024_small_bg
>>>> filesystem.  Doing resize2fs -M on it twice should corrupt it, even on x86_64.
> 
> Sorry - the image as attached is not broken, but 2 current resize2fs -M's break it.
> 
> -Eric
> 
>>>> (aside: the test is a bit weird, it does:
>>>>
>>>> echo $RESIZE2FS $RESIZE2FS_OPTS -d 31 -M $TMPFILE $SIZE_2 >> $LOG 2>&1
>>>>
>>>> but specifying -M as well as a size doesn't make much sense?)
>>>>
>>>> -Eric
>>>>
> 
>>
> 

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.17 (Darwin)
Comment: GPGTools - http://gpgtools.org
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJSJz1fAAoJECCuFpLhPd7gwxoP/A+0ARl3XX6JJV7SfpVhvFKg
qevX6hQnmFD6XgmCnRI1P4SR0NGnfeot8ZIEOGr9W954dENx+9gcF6q6oLUnsrO8
jqBXnUjPIsjYkAD3d5RpK3ygRuOQMMmRtruoSYlEfivG8fYfl0/pbLKDrOhHy/3F
57lsyDwquJhLbIplLu+upe7vctHL9o0QDU0dBVdfrSDTmqD/KOP93qPlK/HfCKip
XzTWENnJmLL8WAG6AfbOfWTFFMnKk2qHdglB4VOdNBqiuCLRytScQc5ordwz/Aip
NIt9FMcjXQoNgu/IlM8m4gH0UTBkMQDw85cojqbIkMmhUX9gtgUepzMmEKnTViCj
iMBM/596dI83Icnh/1nEC/iZ7s0x4yZYwn7l6VTMyW8/gGwYTkGuo4IpD5neeEN6
6b8xRY7YtNdoFlfAWjfssQ7k4JdIPVGX4gJoEyulG4qEJZ70X0R9E8C2tfU3IXSE
YsD9fH+w1o0iaNRpuNXpQ1Jy1uA42UHubYgKnAPsHmbAhHS60woC2/+K1lOi4Ree
ye1tNAVC9edicNi2L+wLrPwxYnMMv2+x8gs5nfM/PoOPhY8BvqJil2r5QHnsa1q1
cOWQfA9GQ0t+IG9TEgIAQqzdh3QZIs6KEIvDHB1IQk544jVbUG35DOaAPxZsNHJa
Cic9x4MFhKsqb+Qb5jw/
=AQPh
-----END PGP SIGNATURE-----
