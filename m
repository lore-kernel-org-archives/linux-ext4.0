From: Sedat Dilek <sedat.dilek@gmail.com>
Subject: Re: [PATCH] xfstests-bld: Simplify determination of number of CPUs in build-all
Date: Sat, 29 Mar 2014 11:04:51 +0100
Message-ID: <CA+icZUUqDVROfgcpULciNaP=h_EJkBJHGCLNHFaNHjEEeVqV5A@mail.gmail.com>
References: <1395997399-3000-1-git-send-email-sedat.dilek@gmail.com>
	<20140328161806.GA31772@thunk.org>
Reply-To: sedat.dilek@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: lsf@lists.linux-foundation.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20140328161806.GA31772@thunk.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Mar 28, 2014 at 5:18 PM,  <tytso@mit.edu> wrote:
> On Fri, Mar 28, 2014 at 10:03:19AM +0100, Sedat Dilek wrote:
>> Use 'getconf _NPROCESSORS_ONLN' to determine the total number
>> of available ("online") CPUs.
>>
>> I have seen this 1st in some build-scripts of Grml project and
>> had some discussions with Thorsten Glaser on this topic.
>>
>> Signed-off-by: Sedat Dilek <sedat.dilek@gmail.com>
>
> Thanks, applied.
>

...and pushed?

> In the future, it would be great at least cc patches to
> linux-ext4@vger.kernel.org, since I rely on patchwork to make sure
> patches don't end up falling through the cracks.
>
> If we start getting a huge number of patches to xfstests-bld, and
> people start getting confused/annoyed about how xfstests-bld issues
> get discussed on linux-ext4@vger.kernel.org, while xfstests patches
> and discussion happen on xfs@oss.sgi.com, we could consider creating a
> new mailing list --- especially given that based on a challenge which
> Greg K-H gave us at the kernel pannel at Collab Summit, we'll at least
> be looking at cleaning up and then trying to get into the linux kernel
> mainline sources some combination of xfstests plus some infrastructure
> automation (perhaps strongly based on what I've been working here in
> the xfstests-bld tree) to run xfstests.
>

Please, document the handling of patches (and where someone can get informed).

- Sedat -
