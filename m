From: Artem Bityutskiy <dedekind1-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/2] ext4: implement cgroup writeback support
Date: Wed, 23 Sep 2015 22:47:16 +0300
Message-ID: <CAF4G-tL9Es57dTE7bDbUdYeQxPYgKct1zn_Zbn8+S9JHMfbsng@mail.gmail.com>
References: <1434495193-31182-1-git-send-email-tj@kernel.org>
	<1434495193-31182-3-git-send-email-tj@kernel.org>
	<20150722035620.GD2944@thunk.org>
	<1443012552.19983.209.camel@gmail.com>
	<20150923172535.GC25218@ret.masoncoding.com>
	<CAF4G-tKEcnVw76-ZU77AjmBDGybLnNEOKjkJtYBN67es0wb30g@mail.gmail.com>
	<20150923175337.GD25218@ret.masoncoding.com>
	<20150923182432.GH3318@thunk.org>
	<CAF4G-t+E89a_A3RzQYB9wXxqE6nM0t7wN6fNmLABZ70=ivHTRQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: "Theodore Ts'o" <tytso-3s7WtUTddSA@public.gmane.org>, Chris Mason <clm-b10kYP2dOMg@public.gmane.org>,
	Artem Bityutskiy <dedekind1-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>,
	axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
	linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org,
	cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org,
	kernel-team-b10kYP2dOMg@public.gmane.org,
	"linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAF4G-t+E89a_A3RzQYB9wXxqE6nM0t7wN6fNmLABZ70=ivHTRQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Sep 23, 2015 at 9:24 PM, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org> wrote:
> Artem,
>
> Can you (or someone on the cgroups list, perhaps) give more details
> about how Fedora 22 sets up groups?
>
> Unfortunately apparently no one has gotten an official Fedora image
> for Google Compute Engine so it's a bit of a pain for me to reproduce
> the problem.  (I suppose I could use AWS, but all of my test
> infrastructure uses GCE, and I'd really rather not have to install a
> Java Runtime on my laptop. :-)

[ My apologies for top posting and for sending HTML e-mails which do
not get through vger.
I am using gmail web interface, and just learned how to send plain
text from here. So re-sending
my longer answer. ]

Hi Ted, Chris, Tejun, all,

quick and probably messy reply before I go to sleep...

I can give more information tomorrow.  But one note - It would be helpful to get
questions like "send us the output of this command" rather than "what are the
cgroups you are in", because I am not fluent with cgroups. IOW, more specific
questions are welcome.

Some more about my setup. I have an number of testboxes, which are 1/2/4-socket
servers. I compile the kernel for them on a separate worker box. Then I copy the
kernel binary to /boot, and the modules to /lib/modules, then run
'sync' and then
reboot to reboot to the new kernel. And vrey often many module files
are corrupted.
They won't load because of majic/crc mismatches.

I copy stuff over scp. Well, this is not exactly scp, but rather a
Python 'scp' module,
which is based on the 'paramiko' module. But I think this should not matter.

Anyway, may be there are some cgroups related with scp/ssh sessions or
/lib/modules
in Fedora 22?

Also note, I tried to be careful during bisecting, I used 4 servers in
parallel, and
did 5 reboot tests on each of them. With this patch reverted all 4
boxes survive 5
reboots just fine. Without this patch reverted, each fail 1-3 reboots.

And, by the way, I forgot this detail - I cut AC power off at the end,
then put it back
on after a 20 seconds delay. I mean, this is a clean reboot, but with
power cut at the
end. So the process is this:

1. I run 'sync' on the box remotely over ssh
2. I run 'reboot'  on the box remotely over ssh, the ssh connection
gets closed at this point
3. I ping the box, and keep doing this until it is stops echoing back
4. I wait several seconds, and then just cut the AC power off. The
wall socket power is off.

So if there was something in, say, SSD cache which was not synced, it
is gone too.

May be this patch reveals an existing issue. My setup has been stable
with 4.2 and many
previous kernels, and it only fails with 4.3-rcX, and my bisecting
lead to this patch.
