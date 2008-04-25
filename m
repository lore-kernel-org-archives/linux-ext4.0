From: "Zdenek Kabelac" <zdenek.kabelac@gmail.com>
Subject: Re: 2.6.25-git2: BUG: unable to handle kernel paging request at ffffffffffffffff
Date: Fri, 25 Apr 2008 14:27:37 +0200
Message-ID: <c4e36d110804250527r663e4736i10455a07d4d15171@mail.gmail.com>
References: <4811090A.9030809@gmail.com>
	 <alpine.LFD.1.10.0804241539150.2779@woody.linux-foundation.org>
	 <4812108D.6020103@gmail.com>
	 <20080425.021301.193689806.davem@davemloft.net>
	 <c4e36d110804250515u713775bdjbb7bfac2d0e83d96@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: jirislaby@gmail.com, torvalds@linux-foundation.org, mingo@elte.hu,
	rjw@sisk.pl, paulmck@linux.vnet.ibm.com,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
	linux-ext4@vger.kernel.org, herbert@gondor.apana.org.au,
	penberg@cs.helsinki.fi, clameter@sgi.com
To: "David Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1762055AbYDYM1v@vger.kernel.org>
In-Reply-To: <c4e36d110804250515u713775bdjbb7bfac2d0e83d96@mail.gmail.com>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

2008/4/25, Zdenek Kabelac <zdenek.kabelac@gmail.com>:
> 2008/4/25, David Miller <davem@davemloft.net>:
>
> > From: Jiri Slaby <jirislaby@gmail.com>
>  >
>  > Date: Fri, 25 Apr 2008 19:10:37 +0200
>  >
>  >
>  >  > I'm going to bisect it, will be back in few hours ;).
>  >
>  >
>  > Thanks for all of this hard work and investigation Jiri!
>  >
>
>
> Well just to show it's not happing only to Jiri:
>

And now tested without the iwl wifi driver loaded:


 ./testf
alloced 0
freed 0
alloced 1
freed 1
alloced 2
WHAT THE HELL (38cdabe8):
ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadccf0
ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22
ff00aa00deadcc22 ff00aa00deadcc22
ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22
ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22
ff00aa00deadcc22 ff00aa00deadcc22
ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22
ff00aa00deadcc22 ff00aa00deadcc22 fff0aa00deadcc22 ff00aa00deadcc22
ff00aa00deadcc22 ff00aa00deadcc22
ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22
ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00f0adcc22 ff00aa00deadcc22
ff00aa00deadcc22 ff00aa00deadcc22
ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22
ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22
ff00aa00deadcc22 ff00aa00deadcc22
ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22
ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22
ff00aa00deadcc22 ff00aa00deadcc22
ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22
ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22
ff00aa00deadcc22 ff00aa00deadcc22
ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22
ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22
ff00aa00deadcc22 ff00aa00deadcc22
ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22
ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22
ff00aa00deadcc22 ff00aa00deadcc22
ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22
ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22
ff00aa00deadcc22 ff00aa00deadcc22
[kabi@localhost ~]$ lsmod
Module                  Size  Used by
nls_iso8859_2           6592  1
nls_cp852               6848  1
vfat                   15808  1
fat                    60936  1 vfat
i915                   37768  2
drm                   109024  3 i915
ipt_MASQUERADE          4800  1
iptable_nat             8144  1
nf_nat                 23440  2 ipt_MASQUERADE,iptable_nat
nf_conntrack_ipv4      20248  4 iptable_nat,nf_nat
xt_state                3456  1
nf_conntrack           73072  5
ipt_MASQUERADE,iptable_nat,nf_nat,nf_conntrack_ipv4,xt_state
ipt_REJECT              4992  2
xt_tcpudp               4288  4
iptable_filter          4736  1
ip_tables              22800  2 iptable_nat,iptable_filter
x_tables               27872  6
ipt_MASQUERADE,iptable_nat,xt_state,ipt_REJECT,xt_tcpudp,ip_tables
bridge                 64504  0
llc                     9584  1 bridge
nfsd                  283752  17
lockd                  78960  1 nfsd
nfs_acl                 4672  1 nfsd
auth_rpcgss            56448  1 nfsd
exportfs                6656  1 nfsd
autofs4                28320  2
sunrpc                234848  15 nfsd,lockd,nfs_acl,auth_rpcgss
binfmt_misc            14604  1
dm_mirror              23864  0
dm_log                 14080  1 dm_mirror
dm_mod                 74424  5 dm_mirror,dm_log
uinput                 11728  0
kvm_intel              30272  0
kvm                   131376  1 kvm_intel
snd_hda_intel         464644  3
snd_seq_oss            38544  0
snd_seq_midi_event      9800  1 snd_seq_oss
snd_seq                64968  4 snd_seq_oss,snd_seq_midi_event
snd_seq_device         10332  2 snd_seq_oss,snd_seq
snd_pcm_oss            49504  0
snd_mixer_oss          19976  1 snd_pcm_oss
snd_pcm                94512  2 snd_hda_intel,snd_pcm_oss
snd_timer              29280  2 snd_seq,snd_pcm
snd                    78312  14
snd_hda_intel,snd_seq_oss,snd_seq,snd_seq_device,snd_pcm_oss,snd_mixer_oss,snd_pcm,snd_timer
rtc_cmos               12856  0
rtc_core               24100  1 rtc_cmos
evdev                  15776  8
video                  25692  0
psmouse                47084  0
thinkpad_acpi          66884  0
iTCO_wdt               15168  0
nvram                  11272  2 thinkpad_acpi
rtc_lib                 4160  1 rtc_core
serio_raw               8772  0
mmc_block              16080  2
soundcore              10848  1 snd
backlight               7064  2 video,thinkpad_acpi
i2c_i801               12124  0
i2c_core               29968  1 i2c_i801
intel_agp              32752  1
button                 10528  0
sdhci                  21260  0
mmc_core               57632  2 mmc_block,sdhci
e1000e                111316  0
iTCO_vendor_support     5124  1 iTCO_wdt
output                  5184  1 video
snd_page_alloc         12304  2 snd_hda_intel,snd_pcm
battery                16656  0
ac                      7816  0
uhci_hcd               29480  0
ohci_hcd               28180  0
ehci_hcd               43156  0
usbcore               177176  4 uhci_hcd,ohci_hcd,ehci_hcd
